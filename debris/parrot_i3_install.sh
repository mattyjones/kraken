#! /usr/bin/env bash

#
# This requires ParrotOS Security Mate
# It produces a tailored setup for i3 (see proj ct README for details)
#

###--------------------------------Global Declarations--------------------------------------###

# Some of these may already be installed, if so they will  not be re-installed or upgraded.

# Pentest and CTF specific packages (these are optional)
pentest_pkgs=("exploitdb" "masscan")

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
i3_pkgs=("lightdm" "xfce4-terminal" "i3" "feh" "polybar" "dunst" "rofi" "ranger" "irssi")

# Additional security and privacy related packages
#security=()

# When removing Gnome and Mate networking packages are removed as well, these will be needed
# for basic connections
network_pkgs=("network-manager" "openconnect")

# pks to remove from a mate install (these are optional)
#remove_pkgs=("gnome*" "mate*")

# The VM share dir
share_dir="sharefs"

# Pinned versions
bat_ver="0.17.1"

# The user that is running the script via sudo. This is necessary to ensure the
# correct permissions are created and files are put in the proper home
# directory.
script_user="$(logname)"

# Tools required to run the script. These should already be installed
required_tools=("curl" "wget")

# Set this to true if we need to do a reboot, specifically for the shell change
reboot=false

###--------------------------------Function Declarations--------------------------------------###

# Check to ensure any tools needed for the uplift are already installed.
# If they are not installed, ask the user if they want to install them. If they decline,
# then the script will exit.
check_tools() {
  local tools=("$@")
  local ans=""
  for t in "${tools[@]}"; do
    if [ ! "$(which "$t")" ]; then
      echo "$t is not installed. Do you wish to install it? [Y/n]"
      read -r ans
      if [[ $ans == "" ]] || [[ $ans == "Y" ]]; then
        echo "Installing $t"
        apt-get install -y "$t" &>/dev/null
      else
        echo"These tools are necessary for the script. Please ensure the are installed before continuing"
        exit 1
      fi
    fi
  done
}

# Check to ensure CTF and HTB packages for the uplift are not already installed.
# If the packages are already installed and we try to do it again, apt will
# get confused and this will cause problems at some point.
check_apt() {
  local pkgs=("$@")
  for p in "${pkgs[@]}"; do
    if [ ! "$(which "$p")" ]; then
      apt-get install -y "$p" &>/dev/null
      return 0
    fi
  done
}

install_pkg_grps() {
  local group_name=$1
  shift
  local pkgs=("$@")
  local ans=""

  if [[ counter -lt 2 ]]; then
    ((counter++))

    echo "Do you wish to install the $group_name group? Type 'l' for a list of packages [Y/n/l]"
    read -r ans
    if [[ $ans == "" ]] || [[ $ans == "Y" ]]; then
      check_apt "${pkgs[@]}"
    elif [[ $ans == "l" ]]; then
      echo "Packages: ", "${pkgs[@]}"
      install_pkg_grps "$group_name" "${pkgs[@]}"
    fi
  else
    return
  fi
}

# Install and provide a baseline configuration for oh-my-zsh that a user can then configure
# to their hearts content for the next four hours.
install_oh_my_zsh() {
  local ans=""

  # Check to see if ZSH is already installed
  if [ ! "$(which "zsh")" ]; then
    echo "ZSH is already installed. Do you wish to install it? This will backup and replace your current configuration [Y/n]"
    read -r ans
    if [[ $ans == "n" ]]; then
      echo "Skipping ZSH installation"
    else
      echo "Installing ZSH"
      su "$script_user" -c "bash -c $(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) "" --unattended"
    fi
  fi

  # Do we want to set it as the default shell
  local ans=""
  echo "Do you want to activate ZSH now and make it your default shell? [Y/n] A reboot should be done when this script is complete"

  read -r ans
  if [[ $ans == "" ]] || [[ $ans == "Y" ]]; then
    enable_zsh
  fi
}

enable_zsh() {
  # Set ZSH as the default shell
  # There is a lot of pam noise and sed going on in here. It is simply due to the fact we are running
  # the script as the root user yet we want to change the shell of the user that invoked it.

  # TODO notifications about this and that it worked
  # TODO is it already the shell

  sed -i.bak '/auth       required   pam_shells.so/a auth       sufficient   pam_wheel.so trust group=chsh' /etc/pam.d/chsh
  groupadd chsh
  usermod -a -G chsh "$script_user"
  su "$script_user" -c "chsh -s $(which zsh)"
  gpasswd -d "$script_user" chsh
  groupdel chsh
  sed -i.bak '/auth       sufficient   pam_wheel.so trust group=chsh/d' /etc/pam.d/chsh

  reboot=true
}

install_bat() {
  # Install bat, which is a vim like replacement for cat
  # https://github.com/sharkdp/bat

  echo "Do you wish to install bat? [Y/n/l]"
  read -r ans
  if [[ $ans == "" ]] || [[ $ans == "Y" ]]; then

    local pkg=""
    pkg=$(echo "https://github.com/sharkdp/bat/releases/download/v\"$bat_ver\"/bat_\"$bat_ver\"_amd64.deb" | rev | cut -d'/' -f 1 | rev)

    wget "https://github.com/sharkdp/bat/releases/download/v\"$bat_ver\"/bat_\"$bat_ver\"_amd64.deb" &>/dev/null
    dpkg -i "$pkg"
    rm "$pkg"

    if [ ! "$(which "bat")" ]; then
      echo "bat was successfuly installed."
      return 0
    else
      echo "bat was not successfully installed"
      return 1
    fi
  else
    echo "bat not installed"
    return 0
  fi
}

install_masscan() {
  # Install a patched version of masscan. The default version has a bug in the wait functionality
  # that causes it to loop indefinitely and cannot not be used in scripts

  echo "Do you wish to update masscan? [Y/n/l]"
  read -r ans
  if [[ $ans == "" ]] || [[ $ans == "Y" ]]; then
    wget https://github.com/robertdavidgraham/masscan/archive/master.zip &>/dev/null
    unzip master.zip && cd masscan-master || echo "masscan package corrupted"

    if [[ $0 -ne 0 ]]; then
      echo "masscan not downloaded correctly"
      return 1
    fi

    make && make install &>/dev/null

    if [[ $0 -ne 0 ]]; then
      echo "masscan was not built and installed correctly"
      return 1
    fi

    cp ./bin/masscan /usr/bin
    return 0

  else
    echo "masscan not updated"
    return 0
  fi
}

create_share() {
  # Create the filesystem

  local ans=""
  echo "Would you like to setup sharing and cut/paste between the host and this vm? [Y/n]"

  read -r ans
  if [[ $ans == "" ]] || [[ $ans == "Y" ]]; then

    # check if the dir already exists
    if [ -d "$share_dir" ]; then
      echo "$share_dir does not exist, creating it"
      mkdir /mnt/$share_dir
    else
      echo "The directory already exists"
    fi

    # make sure the mount point exists
    # Mount the filesystem for usage in this current session
    if grep -qs '/mnt/sharefs ' /proc/mounts; then
      echo "The share has already been mounted"
    else
      mount -t fuse.vmhgfs-fuse .host:/ /mnt/sharefs -o allow_other
    fi

    # Add to /etc/fstab for persistence check if it already exists
    local share=""
    share=$(grep "/mnt/$share_dir" /etc/fstab)

    if [[ $share == "" ]]; then
      echo ".host:/ /mnt/sharefs fuse.vmhgfs-fuse allow_other 0 0" >>/etc/fstab
    else
      echo "This has already been set to auto mount"
    fi
    rerurn 0
  else
    echo "Sharing not configured"
    return 0
  fi
}

cleanup() {

  if [[ $reboot == true ]]; then
    echo "Do you want to reboot now? [Y/n]"
    reqd -r ans

    if [[ $ans == "Y" ]]; then
      init 6
    fi
  else
    echo "It is always a good idea to reboot after configuring a new shell"
  fi
}

main() {
  ###--------------------------------System Updates--------------------------------------###

  # TODO Check for sudo before we do anything

  if [[ $(id) -ne 0 ]]; then
    echo "Sudo is required"
  fi

  # prep work
  apt-get update
  check_tools "${required_tools[@]}"
  cd /tmp || echo "The update failed" | exit

  echo "Do you want to upgrade the system (this may take a while)? [Y/n]"
  read -r ans

  if [[ $ans == "Y" ]]; then
    apt-get full-upgrade
  else
    echo "The system will not be upgraded"
  fi

  ###--------------------------------Package Installation--------------------------------------###

  # Install Package Groups
  # The counter is here and reset everytime to provide a short circuit in the event
  # a user gets stuck in a loop of listing packages or trying to install them
  counter=0
  install_pkg_grps "Development" "${development_pkgs[@]}"

  counter=0
  install_pkg_grps "Windows" "${windows_pkgs[@]}"

  counter=0
  install_pkg_grps "Web" "${web_pkgs[@]}"

  counter=0
  install_pkg_grps "Tool" "${tools_pkgs[@]}"

  counter=0
  install_pkg_grps "Host/VM Sharing" "${share_pkgs[@]}"

  counter=0
  install_pkg_grps "Pentest" "${pentest_pkgs[@]}"

  counter=0
  install_pkg_grps "i3" "${i3_pkgs[@]}"

  # counter=0
  # install_pkg_grps "Security" "${security_pkgs[@]}"

  counter=0
  install_pkg_grps "Network" "${network_pkgs[@]}"

  install_bat

  # TODO check to make sure the version < 1.0.6
  install_masscan

  ###--------------------------------Shell Installation and Configuration--------------------------------------###

  install_oh_my_zsh

  ###--------------------------------System Configurations-------------------------------------###

  create_share

}

main

cleanup

# TODO fix masscan build error
# TODO Fix masscan directory error
# TODO capture return values
# TODO catch warnings
# TODO colored output
# TODO make secure
# TODO quit output
# TODO capture error output and STDERR
# TODO make secure
# TODO quit output
# TODO install oh my zsh
# TODO install airline for vim and terminal
# TODO install nord
# TODO install nord tmux theme
# TODO install zsh-dircolors-nord
# TODO install lightline for nvim
# TODO install nord for nvim
# TODO configure nvim
