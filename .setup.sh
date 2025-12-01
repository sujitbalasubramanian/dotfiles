#!/bin/sh
# This script requires base-devel, sudo to run

sudo pacman -Syu

sudo pacman -S git

yay -Syu $(cat .programs)
