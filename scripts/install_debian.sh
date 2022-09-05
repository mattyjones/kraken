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
#    scripts/install_debian.sh
#
# NOTES:
#
# LICENSE:
#    MIT
#

##--------------------------- Prework ----------------------------------##

# You will need a base installation of Debian 11+. It can be as minimal as you
# want. There are only a few opinionated decisions left in this tool. Once
# this is complete log in and setup a few things. This could be automated as
# well in the future.
#
# There are a lot of steps here just to be clear on the process. In reality,
# once you log in with the default user and install git, the rest can be
# scripted less verbose. I may do it myself at some point, for now I just
# roll back snapshots for testing.
#
# There may be additional steps or different steps depending on the final
# installation. How and for what purpose kraken is used is up to you.

# 1. Install a base image of Debian
# 5. Boot the box and log in
# 6. `sudo su -`
# 7. `useradd -d /home/$USER -G sudo -m $USER`
# 8. `passwd $USER`
# 9. `apt install neovim curl wget git`
# 10. Reboot
# 11. Login with $USER
# 12. `git clone https://github.com/mattyjones/kraken.git`
# 13. `cd kraken`
# 14. `git checkout blackarch`
# 15. See README for details on using kraken

# Get the current working directory for reference. Do not use pwd
# in the script as the current directory could be different
# from the base directory and screw up any relative paths
cwd=$(pwd)

# TODO Create an option for an unattended install
# TODO Create an option for debug statements
# TODO Create a menu for interactive installs
##----------------------- Initialization ---------------------##

# Set the path to include the libraries. These are searched for in the same directory or within the path. We capture
# the original path statement and then prepend the library directory. Once we have sourced all the functions we drop
# back to the original path to minimize possible mangling.
load_library() {

  local ORIG_PATH="$PATH"
  export PATH="scripts/lib:$PATH"

  # source blackarch.sh
  # source development.sh
  # source editors.sh
  # source gui.sh
  # source networking.sh
  # source shell.sh
  # source terminal.sh
  source util.sh
  # source virtualization.sh
  source yaml.sh

  export PATH="$ORIG_PATH"

  return 0
}

# prep work
check_tools "${required_tools[@]}"
apt-get update
cd /tmp
#apt-get full-upgrade

# Check and installl needed packages
check_apt "${i3_pkgs[@]}"
check_apt "${general_pkgs[@]}"
check_apt "${security_pkgs[@]}"

# Initialize gathers basic info, performs any setup configurations and makes
# sure any script dependencies are met. It will not check to see what it is
# running as or if the user is set up correctly. Don't be lazy, don't run
# this as root.
initialize() {

  script_user="$(logname)"
# TODO Check for sudo before we do anything

required_tools=("curl" "wget" "zsh")

  echo -e "\e[$cyan Initializing..."

  # Bring in all necessary libraries and external functions
  load_library

  # Load in the yaml config file
  load_yaml "$cwd/scripts/config.yml"

  # Ask for the administrator password upfront. Do not run the script as root.
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
    package_install curl
  fi

  # Install wget if it is not already present
  if [ ! "$(which wget >/dev/null 2>&1)" ]; then
    package_install wget
  fi

  echo "Initialization complete"
  return 0
}

##--------------------------- Main -------------------------##
main() {

  # TODO set all these as global variables in the install script
  local VERSION="0.0.1"

  # FIXME fix the colors with the same number (orange and yellow)
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
  # TODO break this out into a seprate function
  echo -e "\n\e[$blue#########################################################\e[$default"
  echo -e "\n\e[$cyan Kracken - Automated Debian Linux Pentesting Environment"
  echo -e "\e[$cyan @mattyjones | github.com/mattyjones"
  echo -e "\e[$cyan Version: $VERSION"
  echo -e "\n\e[$blue#########################################################\e[$default"
  printf "\n\n\n"

  # Initialize the script and ensure we have a correct baseline image
  if ! initialize; then
    echo -e "\n\e[$red Initialization failed\e[$default"
    exit 1
  fi

  # When installing only specific pieces you may need to modify the
  # script to ensure tools are available as needed. This may not be
  # called out and the tool will break if certain build tools and headers
  # are not present as dependencies.
  # TODO break this out into a separate function
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

  if [[ $packages_editors_install == "true" ]]; then
    if ! editors_main; then
      echo -e "\n\e[$red Editing tools installation failed\e[$default"
      exit 1
    fi
  fi

  if [[ $packages_terminal_install == "true" ]]; then
    if ! terminal_main; then
      echo -e "\n\e[$red Terminal tools installation failed\e[$default"
      exit 1
    fi
  fi

    if [[ $packages_development_install == "true" ]]; then
      if ! development_main; then
        echo -e "\n\e[$red Development tools installation failed\e[$default"
        exit 1
      fi
  fi

  if [[ $packages_shell_install == "true" ]]; then
    if ! shell_main; then
      echo -e "\n\e[$red Shell tools and configs installation failed\e[$default"
      exit 1
    fi
  fi

  if [[ $packages_virtualization_install == "true" ]]; then

    if ! virtualization_main; then
      echo -e "\n\e[$red Virtualization tools and configs installation failed\e[$default"
      exit 1
    fi
  fi

  # Misc bits and pieces
  # configure_gpg
  #  configure_wraith

 # TODO create some sort of a cleanup script to clean the tmp directory, cache, etc
 #  at the end of the run. This would also be called during a failed state to ensure
 #  the environment was left as stable as possible
  echo -e "\n\e[$blue#########################################################\e[$default"
  echo -e "\n\e[$orange All done. Go be a creepy human\e[$default"
  echo -e "\n\e[$blue#########################################################\e[$default"

  exit 0

}

main
# TODO tests?
# reboot so things can take effect
# should ask to do this
#init 6
# do we want to set zsh as the shell
# quit output
# capture error output and STDERR
# catch warnings
# colored output


