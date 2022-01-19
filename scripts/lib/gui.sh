#! /bin/bash

##----------------------- GUI ---------------------##

# 
install_xorg() {
  local pkgs=("xorg-server" "xorg-xinit" "xorg-xkill" "moreutils")
  package_install "${pkgs[@]}"

  return 0
}

install_xfce() {
  local pkgs=("lxdm-gtk3" "xfce4" "xfce4-goodies" "lightdm-gtk-greeter")
  package_install "${pkgs[@]}"

  sudo systemctl enable lightdm.service

  return 0
}

install_fonts() {
  local pkgs=("fontconfig" "ttf-fira-code")
  package_install "${pkgs[@]}"

  #this is done after the fonts are installed
  sudo fc-cache

  return 0
}

install_media_tools() {
  local pkgs=("vlc")
  package_install "${pkgs[@]}"

  return 0
}

gui_main() {
    install_xorg
    install_xfce
    install_fonts
    install_media_tools

    return 0
}
