#! /bin/env bash

##--------------------------- Utility Functions ------------------------##

# install will install a package or group of packages using a common set of options.
# All packages should be installed using this function to ensure testability and
# uniformity.
package_install() {
  local pkgs=("$@")
  # local pkg_list=("pacman -Qe")

  for t in "${pkgs[@]}"; do
    # if find . | grep -q 'IMG[0-9]'
    # shellcheck disable=2143
    if [ ! "$(pacman -Q | grep "$t")" ]; then

      if [ ! "$(sudo pacman -S --noconfirm -q "$t")" ]; then
        echo "Package install failed"
        exit 1
      fi
    fi
  done

  return 0
}

system_upgrade() {
  if [ ! "$(sudo pacman -S --sysupgrade --refresh --noconfirm)" ]; then
    echo "System update failed"
    exit 1
  else
    echo "System update complete"
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
        echo "Failed to create path."
        echo "This function develes not run as a privilaged user. Check your permissions"

        exit 1
      fi
    fi
  done

  return 0
}
