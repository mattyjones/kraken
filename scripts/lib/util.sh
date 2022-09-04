#! /bin/env bash

##--------------------------- Utility Functions ------------------------##

# Install will install a package or group of packages using a common set of options.
# All packages should be installed using this function to ensure testability and
# uniformity.
# TODO use color in the output
# TODO check to make sure package installed correctly
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

# This will update the package lists and any packages that are already installed to
# the latest versions.
system_upgrade() {
  if [ ! "$(sudo apt update && apt upgrade)" ]; then
    echo -e "\n\e[$red System upgrade failed\e[$default"
    exit 1
  else
    echo -e "\n\e[$cyan System update complete\e[$default"
    echo ""
  fi

  return 0
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
