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

# You will need a base installation of Debian Bullseye. It can be as minimal as you
# want. There are only a few opinionated decisions left in this tool. Once
# this is complete log in and set up a few things including a non-priv user with sudo. This could be automated as
# well in the future.
#
# There are a lot of steps here just to be clear on the process. In reality,
# once you log in with the default user and install git, the rest can be
# scripted less verbose. I may do it myself at some point, for now I just
# roll back snapshots for testing.
#
# There may be additional steps or different steps depending on the final
# installation. How and for what purpose kraken is used is up to you.

# TODO Create an option for an unattended install
# TODO Create an option for debug statements
# TODO Create a menu for interactive installs
##----------------------- Initialization ---------------------##

# Set the path to include the libraries. These are searched for in the same directory or within the path. We capture
# the original path statement and then prepend the library directory. Once we have sourced all the functions we drop
# back to the original path to minimize path mangling.
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
  source system.sh

  export PATH="$ORIG_PATH"

  return 0
}

# Initialize gathers basic info, performs any setup configurations and makes
# sure any script dependencies are met. It will not check to see what it is
# running as or if the user is set up correctly. Don't be lazy, don't run
# this as root.
initialize() {

  script_user="$(logname)"

  required_tools=("curl" "wget" "git")

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

  echo -e "\n\e[$cyan Initializing...\n\e[$default"

#  # Bring in all necessary libraries and external functions
#  load_library

  # Load in the yaml config file
  load_yaml "$cwd/scripts/config.yml"

  # Allow the user to set the debian source branch to track
  set_debian_source "bullseye"

  # Upgrade the entire system to ensure we have a stable platform
  system_upgrade

  # FIXME This is supper ugly and needs to be cleaner with the functions
  # Install curl if it is not already present
  if [ ! "$(which curl >/dev/null 2>&1)" ]; then
    package_install curl
  fi

  # FIXME This is supper ugly and needs to be cleaner with the functions
  # Install wget if it is not already present
  if [ ! "$(which wget >/dev/null 2>&1)" ]; then
    package_install wget
  fi

  # FIXME This is supper ugly and needs to be cleaner with the functions
 # Install git if it is not already present
  if [ ! "$(which git >/dev/null 2>&1)" ]; then
    package_install git
  fi
  echo "Initialization complete"
  return 0
}

# Bring in all necessary libraries and external functions
load_library

##--------------------------- Main -------------------------##
main() {

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


