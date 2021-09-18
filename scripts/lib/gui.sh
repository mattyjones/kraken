#! /bin/bash

##----------------------- XORG ---------------------##


install_xorg() {
  local pkgs=("xorg-server" "xorg-init" "xorg-xkill" "more-utils")
  package_install pkgs

}

install_xfce() {
  local pkgs=("lxdm-gtk3" "xfce4" "xfce4-goodies" "lightdm-gtk-greeter")
  package_install pkgs

  sudo systemctl enable lightdm.service
}

install_fonts() {
  local pkgs=("fontconfig" "ttf-firacode")
  package_install pkgs

  #this is done after the fonts are installed
  sudo fc-cache
}

# bash profile to startx x at login
# if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  # exec startx
# fi

# init=/bin/bash                 #(single user)
# systemd.unit=multi-user.target #(runlevel 3)
# systemd.unit=rescue.target     #(runkevel 1)
