#! /bin/env bash
#
#  Kraken
#
# AUTHOR: Matt Jones
#
# DESCRIPTION:
#    Kraken is a semi-automated and opinionated environment configuration tool.
#    Application and tool specific configurations are easy to modify. All tools
#    are built and installed as isolated as possible to ensure modularity and
#    user specific tastes.
#
# OUTPUT:
#    plain-text
#
# PLATFORMS:
#    Arch Linux
#
# DEPENDENCIES:
#    bash
#
# USAGE:
#    scripts/install_arch.sh
#
# NOTES:
#
# LICENSE:
#    MIT
#

##--------------------------- Prework ----------------------------------##

# You will need to download and unpack a vagrant image. This is the smallest pre-built
# image availabe that I am aware of. Once this is complete log in and setup a few things.
# There are a lot of steps here just to be clear on the process. In reality, once you log
# in with the vagrant user and install git, the rest can be scripted easily. I may do it myself
# at some point, for now I just rollback snapshots.

# 1. https://app.vagrantup.com/archlinux/boxes/archlinux
# 2. Download the virtualbox image above or an Arch iso
# 2. `tar -xf <image>`
# 3. Import the box into vmware fusion using the box.ovf file
# 4. Customize the virtual machines settings to match your hardware
# 5. Boot the box and login w/ vagrant:vagrant
# 6. `sudo su -`
# 7. `useradd -d /home/$USER -G wheel -m $USER`
# 8. `passwd $USER`
# 9. `pacman -Syu vi curl wget git`
# 10. Enable the wheel group in sudoers, do not enable NOPASSWD: ALL
# 11. Reboot
# 12. Login with $USER
# 13. `git clone https://github.com/mattyjones/kraken.git`
# 14. `cd kraken`
# 15. `git checkout blackarch`
# 16. See README for details on using kraken

##----------------------- Initialization ---------------------##

# Set the path to include the libraries. These are searched for in the same directory or within the path. We capture
# the original path statement and then prepend the library directory. Once we have sourced all the functions we drop
# back to the original path to minimize possible mangling.
load_library() {

  local ORIG_PATH="$PATH"
  export PATH="scripts/lib:$PATH"

  #  source blackarch.sh
  #  source development.sh
  #  source editor.sh
  source gui.sh
  #  source networking.sh
  #  source shell.sh
  #  source terminal.sh
  source util.sh
  #  source vmware.sh
  source yaml.sh

  export PATH="$ORIG_PATH"

  return 0
}

# Initialize gathers basic info, performs any setup configurations and makes
# sure any script dependencies are met. It will not check to see what it is
# running as or if the user is setup correctly. Don't be lazy, don't run
# this as root.
initialize() {
  echo -e "\e[$cyan Initializing..."
  # echo "Starting initization..."

  # Get the current working directory for reference. Do use pwd
  # in the script as the current directory could be different
  # from the base directory and screw up any relative paths
  cwd=$(pwd)

  # Bring in all necessary libraries and external functions
  load_library

  # Load in the yaml config file
  load_yaml "$cwd/scripts/config.yml"

  # Ask for the administrator password upfront. Do run the script as root.
  # This should always be run as the user whose account will be used. Sudo
  # may be needed for specific actions so that is called up front so automation
  # does not break.
  sudo -v

  # Keep-alive: update existing `sudo` time stamp until we have finished. This
  # ensures that sudo does not expire before the script completes.
  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done 2>/dev/null &

  # Upgrade the entire system to ensure we have a stable platform
  system_upgrade

  # Install curl if it is not already present
  if [ ! "$(which curl >/dev/null 2>&1)" ]; then
    echo "Installing curl"
    package_install curl
  fi

  # Install wget if it is not already present
  if [ ! "$(which wget >/dev/null 2>&1)" ]; then
    echo "Installing wget"
    package_install wget
  fi

  echo "Initilization complete"
  return 0
}

##--------------------------- Main -------------------------##
main() {

  local VERSION="0.0.1"

  # Colors
  red="0;31m"
  green="0;32m"
  orange="0;33m"
  blue="0;34m"
  purple="0;35m"
  cyan="0;36m"
  white="1;37m"
  yellow="1;33m"
  default="0m"

  # Script header
  echo -e "\n\e[$blue#########################################################\e[$default"
  echo -e "\n\e[$cyan Kracken - Automated Arch Linux Pentesting Environment"
  echo -e "\e[$cyan @mattyjones | github.com/mattyjones"
  echo -e "\e[$cyan Version: $VERSION"
  echo -e "\n\e[$blue#########################################################\e[$default"
  printf "\n\n\n"

  # Initialize the script and ensure we have a correct baseline image
  if ! initialize; then
    echo -e "\n\e[$red Initialization failed\e[$default"
    exit 1
  fi

  if [[ $packages_gui_install == "true" ]]; then

    if ! gui_main; then
      echo -e "\n\e[$red Gui installation failed\e[$default"
      exit 1
    fi

  fi

  if [[ $packages_networking_install == "true" ]]; then

    if ! networking_main; then
      echo -e "\n\e[$red Browsers and networking tools installation failed\e[$default"
      exit 1
    fi

  fi
  # When installing only specific pieces you may need to modify the
  # script to ensure tools are available as needed. This may not be
  # called out and the tool will break if certain build tools and headers
  # are not present as dependencies.

  # Install as many of the packages I need as I can
  # install_homebrew

  # Setup my terminals
  #configure_alacritty
  # configure_tmux

  # Setup my shell environment
  #  configure_oh_my_zsh
  #  configure_shell_env
  #  install_dircolors

  # Setup development specific bits
  #  configure_starship
  #  configure_git
  # install_cpan
  #  install_ruby
  #  install_editorconfig
  #  configure_wraith

  # Configure my editors
  #  configure_nvim

  # Misc bits and pieces
  # configure_gpg

  # sudo pacman -S -cc (cleanup)
  echo -e "\n\e[$blue#########################################################\e[$default"
  echo -e "\n\e[$orange All done. Go be a creepy human\e[$default"
  echo -e "\n\e[$blue#########################################################\e[$default"

  exit 0

}

main
# TODO tests?

#main
#
#
#
#cleanup() {
#
#  if [[ $reboot == true ]]; then
#    echo "Do you want to reboot now? [Y/n]"
#    reqd -r ans
#
#    if [[ $ans == "Y" ]]; then
#      init 6
#    fi
#  else
#    echo "It is always a good idea to reboot after configuring a new shell"
#  fi
#}
#
#
#
#
## Various tools I find useful and helpful (these are optional)
#tools_pkgs=("jq" "bat" "rsync" "gvfs")
#
#network_pkgs=("network-manager" "openconnect")
#
## The VM share dir
#share_dir="sharefs"
#
## Set this to true if we need to do a reboot, specifically for the shell change
#reboot=false
