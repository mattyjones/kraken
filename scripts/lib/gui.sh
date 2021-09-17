#! /bin/env bash

##----------------------- XORG ---------------------##

# The vmware section will install the tools and then setup the folder sharing and
# permissions. Cut and paste capability between the host and the server will also
# be setup.

install_xorg() {
  local pkgs=("xorg-server" "xorg-init" "xorg-xkill" "more-utils")

}

install_xfce() {
  local pkgs=("lxdm-gtk3" "xfce4" "xfce4-goodies")
}

install_fonts() {
  local pkgs=("fontconfig" "ttf-firacode")

  #this is done after the fonts are installed
  sudo - $(sudo fc-cache)
}

# bash profile to startx x at login
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec startx
fi


sudo systemctl enable lightdm.service

sudo pacman -S lightdm-gtk-greeter

init=/bin/bash                 #(single user)
systemd.unit=multi-user.target #(runlevel 3)
systemd.unit=rescue.target     #(runkevel 1)
