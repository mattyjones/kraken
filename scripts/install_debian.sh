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

# shellcheck disable=SC2155
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

  # source development.sh
  source editors.sh
  # source eye_candy.sh
  source gui.sh
  # source networking.sh
  # source pentest_tools.sh
  # source security.sh
  # source shell.sh
  source system.sh
  # source terminal.sh
  source util.sh
  # source virtualization.sh
  source yaml.sh

  export PATH="$ORIG_PATH"

  return 0
}

# Initialize gathers basic info, performs any setup configurations and makes
# sure any script dependencies are met. It will not check to see what it is
# running as or if the user is set up correctly. Don't be lazy, don't run
# this as root.
initialize() {

  script_user="$(logname)"

  # Ask for the administrator password upfront. Do not run the script as root.
  # This should always be run as the user whose account will be used. Sudo
  # may be needed for specific actions so that is called up front so automation
  # does not break.
  sudo -v
  check_error "$?"

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
  check_error "$?"

  # Upgrade the entire system to ensure we have a stable platform
  system_upgrade
  check_error "$?"

  # Install the required tools for the script to run
  required_tools=("curl" "wget" "git")
  package_install "${required_tools[@]}"
  check_error "$?"

  echo "Initialization complete"
  return 0
}

##--------------------------- Main -------------------------##

# Bring in all necessary libraries and external functions
if ! load_library; then
  echo "Loading the library failed"
  exit 1
fi

main() {

  # clear the screen
  clear

  # Print the script header
  print_header

  # Initialize the script and ensure we have a correct baseline image
  if ! initialize; then
    echo -e "\n\e[$red Initialization failed\e[$default"
    exit 1
  fi

  # When installing only specific pieces you may need to modify the
  # script to ensure tools are available as needed. This may not be
  # called out and the tool will break if certain build tools and headers
  # are not present as dependencies.
  local pkg_list="$(set -o posix; set | grep 'packages_' | awk -F= '{ print $1 }' | grep packages)"
  for p in $pkg_list; do
    local pkg_selector="$(echo $p | awk -F'_' '{ print $2 }')"
           local install_func="$pkg_selector'_main'"
    if [[ $p == "true" ]]; then
      if ! "$install_func"; then
        echo -e "\n\e[$red Gui installation failed\e[$default"
        exit 1
      fi
    fi
  done
# TODO ^^^ does this damn thing work
# Print the footer for the script
print_footer

# Cleanup and debris and reboot if requested
cleanup
exit 0
}

main



