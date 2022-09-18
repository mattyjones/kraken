#! /bin/bash

source util.sh
source security.sh # required for Tor

#TODO Complete the GUI file

##----------------------- GUI ---------------------##

# install_xorg will install a basic set of gui functions. Not necessary for anything but a bare bones or server install
install_xorg() {
  local pkgs=("xorg-server" "xorg-xinit" "xorg-xkill" "moreutils")
  package_install "${pkgs[@]}"
  check_error $?

  return 0
}

configure_xfce4() {
  # TODO placeholder

  return 0
}

# install_xfc will install a basic xfce environment. Configuration should be done in a
# separate function called from here.
install_xfce() {
  local pkgs=("xfce4" "xfce4-goodies" "lightdm-gtk-greeter")
  package_install "${pkgs[@]}"
  check_error $?

  # Enable the service
  sudo systemctl enable lightdm.service
  check_error $?

  # Set the greeter
  sudo dpkg-reconfigure lightdm
  check_error $?

  # configure_xfce4 will install configuration files or run any additional setup commands
  configure_xfce4

  return 0
}

# configure_i3 will install configuration files or run any additional setup commands
configure_i3() {
  # TODO placeholder

  return 0
}

# install_i3 will install a complete 13 environment. Configuration should be done in a
# separate function called from here.
install_i3() {
  # Ensure the basic XORG bits are present
  install_xorg
  local pkgs=("network-manager" "lightdm-gtk-greeter" "i3" "feh" "polybar" "dunst" "rofi" "ranger" "irssi")
  package_install "${pkgs[@]}"
  check_error $?

  # Enable the service
  sudo systemctl enable lightdm.service
  check_error $?

  # Set the greeter
  sudo dpkg-reconfigure lightdm
  check_error $?

  # Configure i3
  configure_i3

  return 0
}

# install_fonts will install any required fonts and enable them
install_fonts() {
  local pkgs=("fontconfig" "ttf-fira-code")
  package_install "${pkgs[@]}"
  check_error $?

  #fc-cache rebuilds the font library, new fonts are not available till this completes
  sudo fc-cache
  check_error $?

  return 0
}

# install_media_tools will install any common media tools and codecs necessary
install_media_tools() {
  local pkgs=("vlc")
  package_install "${pkgs[@]}"
  check_error $?

  return 0
}

# install_browsers will install any browsers. Configuration should be done in a
## separate function called from here.
install_browsers() {
  local pkgs=("firefox")
  package_install "${pkgs[@]}"
  check_error $?

  # Ensure Tor is install properly. Manual configuration of the browser will still be required

  return 0
}

# configure_wine will install configuration files or run any additional setup commands. Installing any wine
# apps should be done in an additional function and from the install_wine function
configure_wine() {
  # TODO placeholder

  return 0
}

# install_wine_apps will install any wine apps
install_wine_apps() {
  # TODO placeholder

  return 0
}

# Install_wine will install a basic wine environment. Configuration should be done in a
## separate function called from here.
install_wine() {
  local pkgs=("wine")
  package_install "${pkgs[@]}"
  check_error $?

  configure_wine
  check_error $?

  install_wine_apps
  check_error $?

  return 0
}

# main is the main entry point for the gui module. Functions should only be called from here and can be
# created or commented out as needed. Calling specific functions from the debian install script
# could cause dependency issues or create unresolved errors.
gui_main() {
  install_xfce
  # install_i3
  install_fonts

  # These require a GUI or some sort
  install_media_tools
  install_browsers
  # install_wine

  return 0
}
