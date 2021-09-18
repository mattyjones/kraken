#! /bin/bash

##----------------------- XORG ---------------------##


install_xorg() {
  local pkgs=("xorg-server" "xorg-xinit" "xorg-xkill" "moreutils")
  package_install "${pkgs[@]}"

}

install_xfce() {
  local pkgs=("lxdm-gtk3" "xfce4" "xfce4-goodies" "lightdm-gtk-greeter")
  package_install "${pkgs[@]}"

  sudo systemctl enable lightdm.service
}

install_fonts() {
  local pkgs=("fontconfig" "ttf-fira-code")
  package_install "${pkgs[@]}"

  #this is done after the fonts are installed
  sudo fc-cache
}
