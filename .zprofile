#!/bin/sh

# xdg base
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CACHE_HOME=$HOME/.cache
export XDG_STATE_HOME=$HOME/.local/state

# sdk path
export JAVA_HOME=/usr/lib/jvm/default
export GOPATH=$XDG_DATA_HOME/go
export CARGO_HOME=$XDG_DATA_HOME/cargo
export RUSTUP_HOME=$XDG_DATA_HOME/rustup
export ANDROID_HOME=$XDG_DATA_HOME/Android/Sdk
export ANDROID_SDK_ROOT=$XDG_DATA_HOME/Android/Sdk
export PYENV_ROOT=$XDG_DATA_HOME/pyenv
export NVM_DIR=$XDG_DATA_HOME/nvm
export VCPKG_ROOT=$XDG_DATA_HOME/vcpkg

# executables
export PATH=$XDG_DATA_HOME/npm/bin:$PATH
export PATH=$CARGO_HOME/bin:$PATH
export PATH=$GOROOT/bin:$GOPATH/bin:$PATH
export PATH=$ANDROID_HOME/tools:$PATH
export PATH=$ANDROID_HOME/tools/bin:$PATH
export PATH=$ANDROID_HOME/platforms:$PATH
export PATH=$ANDROID_HOME/platform-tools:$PATH
export PATH=$ANDROID_HOME/emulator:$PATH
export PATH=$PYENV_ROOT/bin:$PATH
export PATH=$XDG_CONFIG_HOME/shell/scripts:$PATH

# programs
export TERM="xterm-256color"
export COLORTERM="truecolor"
export TERMINAL="wezterm"
export BROWSER="firefox"
export EDITOR="nvim"
export VISUAL="nvim"
export READER="zathura"
export PAGER="less -RF"
export VIDEO="mpv"
export IMAGE="swayimg"
export OPENER="xdg-open"

export QT_QPA_PLATFORMTHEME=qt6ct

[ "$(tty)" = "/dev/tty1" ] && exec sway
