#! /bin/env bash

# TODO complete the util file

##--------------------------- Global Variables ------------------------##

  # Colors
  # FIXME fix the colors with the same number (orange and yellow)
  red="0;31m"
  green="0;32m"
  orange="0;33m"
  blue="0;34m"
  purple="0;35m"
  cyan="0;36m"
  white="1;37m"
  yellow="1;33m"
  default="0m"

# Get the current working directory for reference. Do not use pwd
# in the script as the current directory could be different
# from the base directory and screw up any relative paths
cwd=$(pwd)

# The current version of the script. This follows semver
VERSION="0.0.1"

##--------------------------- Utility Functions ------------------------##

# package_install installs a package or group of packages using a common set of options.
# All packages should be installed using this function to ensure testability and
# uniformity.
package_install() {
  local pkgs=("$@")

  for p in "${pkgs[@]}"; do
    if [[ ("$(dpkg -l "$p")") || ( "$(which "$p")") ]]; then
      echo "$p is already installed"
      return 0
    elif [[ ( ! "$(dpkg -l "$p")") && ( ! "$(which "$p")") ]]; then
      echo "Installing $p"
      if ! apt-get install -y $p; then
        echo -e "\n\e[$red Failed to install $p\e[$default"
        return 1
      else
        echo "$p installed successfully"
        return 0
      fi
    fi
  done

  # Return 1 by default as a defensive measure of an unknown failure
  return 1
}

# create_path provides a consistent way to create any necessary paths. This should not run
# with elevated privileges. You should instead create the path with sudo. If you
# really know what you are doing, then run this function as sudo.
create_path() {
  local paths=("$@")

  for p in "${paths[@]}"; do
    if [[ -d "$p" ]]; then
      echo "Path already exists"
    else
      if [ ! "$(mkdir -p "$p")" ]; then
        echo -e "\n\e[$red Failed to create path\e[$default"
        echo -e "\n\e[$red This function should not run as a privilaged user. Check your permissions\e[$default"
        exit 1
      fi
    fi
  done

  # Return 1 by default as a defensive measure of an unknown failure
  return 1
}

# check_error is a generic error handling function to clean up and reuse any code possible
check_error() {
  exit_code="$1"

  if [ $exit_code -ne 0 ]; then
    echo -e "\n\e[$red Script exiting due to errors\n\e[$default"
    exit 1
  fi
}

# print_header will print the header for the script
print_header() {

  echo -e "\n\e[$blue#########################################################\e[$default"
  echo -e "\n\e[$cyan Kracken - Automated Debian Linux Pentesting Environment"
  echo -e "\e[$cyan @mattyjones | github.com/mattyjones"
  echo -e "\e[$cyan Version: $VERSION"
  echo -e "\n\e[$blue#########################################################\e[$default"
  printf "\n\n\n"
}

# print_footer will pring the footer for the script
print_footer() {

  echo -e "\n\e[$blue#########################################################\e[$default"
  echo -e "\n\e[$orange All done. Go be a creepy human\e[$default"
  echo -e "\n\e[$blue#########################################################\e[$default"
}

# cleanup will do anything needed to ensure the environment is not poluted or mangled.
# It will also do a full restart if requested
cleanup() {

  if [[ "$reboot_on_finish" == true ]]; then
    echo "Do you want to reboot now? [Y/n]"
    reqd -r ans

    if [[ ( "$ans" == "Y" ) || ( "$ans" == "y" ) ]]; then
      init 6
      check_error $?
    fi
  else
    echo "It is always a good idea to reboot after configuring a new shell. Especially given
          the amount of work we just did."
    exit 0
  fi
}
