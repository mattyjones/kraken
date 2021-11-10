#! /bin/env bash

###--------------------------------Global Packages--------------------------------------###

# Tools required to run the script. These should already be installed
required_tools=("curl" "wget")

# Some of these may already be installed, if so they will not be re-installed or upgraded.

# Pentest and CTF specific packages (these are optional)
pentest_pkgs=( "exploitdb" "masscan")

# Base firefox (these are optional)
web_pkgs=("firefox")

# Wine, fo use specific reverse engineering tools or doing ctf work (these are optional)
windows_pkgs=("wine")

# Editors (these are optional)
development_pkgs=("neovim" "vscodium")

# Various tools I find useful and helpful (these are optional)
tools_pkgs=("jq" "lnav" "tmux" "zsh" "bat")

# packages to allow sharing data, including cut/paste with the host OS (these are optional)
share_pkgs=("open-vm-tools" "open-vm-tools-desktop")

# i3 specific packages needed to bring up a simple i3 setup
i3_pkgs=( "lightdm" "xfce4-terminal"  "i3" "feh" "polybar" "dunst" "rofi" "ranger" "irssi")

# Additional security and privacy related packages
#security=()

# When removing Gnome and Mate networking packages are removed as well, these will be needed
# for basic connections
network_pkgs=("network-manager" "openconnect")


##---------------------- System Updates --------------------##

# This will update the entire distribution and attempt to fix any previous broken
# installs or upgrades. When using automation for these tasks, apt-get is a
# better tool than apt.
update_parrot() {

  # update apt package manager
  apt-get update

  # attempt to fix any previous upgrades that failed to complete
  dpkg --configure -a

  # attempt to fix any conflicts in previous package installs
  apt-get --fix-broken --fix-missing install

  # upgrade all packages
  apt-get upgrade

  # update to the latest distribution version
  /usr/bin/parrot-upgrade

  return 0
}

##---------------------- Install Packages --------------------##

# Check to ensure any tools needed for the uplift are already installed.
install_packages() {
  local tools=("$@")
  local ans=""
  for t in "${tools[@]}"; do
    if [ ! "$(which "$t")" ]; then
          apt-get install -y "$t" &> /dev/null
    fi
  done

  return 0
}

##---------------------- Install CPAN --------------------##

# Install and configure cpan. I need Perl some some specific projects.
install_cpan() {

  echo "configuring cpan"
  sudo cpan App::cpanminus

  return 0
}