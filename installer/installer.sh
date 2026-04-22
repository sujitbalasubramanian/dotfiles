#!/bin/bash
set -e

# Ensure script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# steps:
# install base-devel and git and sudo
echo "Installing base-devel, git, and sudo..."
pacman -Syu --needed --noconfirm base-devel git sudo

# then install sudo and ask fro user and pwd
echo "Please enter details for the new user."
read -p "Enter new username: " NEW_USER

if id "$NEW_USER" &>/dev/null; then
  echo "User $NEW_USER already exists. Skipping user creation."
else
  useradd -m "$NEW_USER"
  passwd "$NEW_USER"
fi

# add the user to sudoers file
echo "Adding $NEW_USER to sudoers..."
echo "$NEW_USER ALL=(ALL:ALL) ALL" > "/etc/sudoers.d/$NEW_USER"
chmod 0440 "/etc/sudoers.d/$NEW_USER"

# Temporarily allow passwordless sudo for makepkg and yay
echo "$NEW_USER ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/99_installer_tmp"
chmod 0440 "/etc/sudoers.d/99_installer_tmp"

# then clonse and build yay 
echo "Cloning and building yay..."
sudo -u "$NEW_USER" bash -c '
  cd /tmp
  rm -rf yay
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
'

# with with yay, install the pages in programs file
echo "Installing packages from programs file..."
if [ -f "$SCRIPT_DIR/programs" ]; then
  mapfile -t pkgs < <(grep -v '^[[:space:]]*$' "$SCRIPT_DIR/programs")
  if [ ${#pkgs[@]} -gt 0 ]; then
    sudo -u "$NEW_USER" yay -S --needed --noconfirm "${pkgs[@]}"
  fi
else
  echo "Warning: $SCRIPT_DIR/programs file not found!"
fi

# the add these groups to the user: libvirt docker video render input audio wheel dialout
echo "Adding user to groups..."
for group in libvirt docker video render input audio wheel dialout; do
  groupadd -f "$group" || true
done
usermod -aG libvirt,docker,video,render,input,audio,wheel,dialout "$NEW_USER"

# enable bluetooth, libvirt and docker services
echo "Enabling services..."
systemctl enable bluetooth.service || true
systemctl enable libvirtd.service || true
systemctl enable docker.service || true
systemctl enable NetworkManager.service || true
systemctl enable tlp.service || true

# clone dotfiles and stow
echo "Cloning dotfiles and applying stow..."
sudo -u "$NEW_USER" bash -c '
  git clone https://github.com/sujitbalasubramanian/dotfiles.git ~/.dotfiles
  cd ~/.dotfiles
  stow . -t ~
'

# Cleanup
rm -f "/etc/sudoers.d/99_installer_tmp"

echo "Installation complete!"
