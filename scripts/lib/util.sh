#! /bin/env bash

# TODO complete the util file

##--------------------------- Global Variables ------------------------##
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

# Get the current working directory for reference. Do not use pwd
# in the script as the current directory could be different
# from the base directory and screw up any relative paths
cwd=$(pwd)

# The current version of the script. This follows semver
VERSION="0.0.1"

##--------------------------- Utility Functions ------------------------##

# Install will install a package or group of packages using a common set of options.
# All packages should be installed using this function to ensure testability and
# uniformity.
# TODO use color in the output
# TODO check to make sure package installed correctly
# NOTE do we need this function or should be always use the check function to install
package_install() {
  local pkgs=("$@")

  for p in "${pkgs[@]}"; do
    if [ ! "$(dpkg -l "$p")" ]; then
      echo "Installing $p"
      apt-get install -y $p
    else
      echo "$p is already installed"
    fi
  done

  return 0
}

# TODO use color in the output
# TODO check to make sure package installed correctly
check_tools() {
tools=("$@")
for t in "${tools[@]}";
do
if [ ! "$(which $t)" ]
then
        echo "$t is not installed."
        # TODO we should ask if they want to install this
        echo "Installing $t"
        apt-get install -y $t
fi
done
}


check_apt() {
pkgs=("$@")
for p in "${pkgs[@]}";
do
if [ ! "$(dpkg -l "$p")" ]
then
        echo "$p is not installed."
        # TODO we should ask if they want to install this
        echo "Installing $p"
        apt-get install -y $p
fi
done
}

# This provides a consistent way to create any necessary paths. This should not run
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

  return 0
}
