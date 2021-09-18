#! /bin/env bash

##--------------------------- Utility Functions ------------------------##

# install will install a package or group of packages using a common set of options.
# All packages should be installed using this function to ensure testability and
# uniformity.
package_install() {
  local pkgs=("$@")

  for t in "${pkgs[@]}"; do
    # shellcheck disable=2143
    if [ ! "$(pacman -Q | grep "$t")" ]; then

      if [ ! "$(sudo pacman -S --noconfirm --needed -q "$t")" ]; then
        # shellcheck disable=SC2154
        echo -e "\n\e[$red Package $t failed to install\e[$default"
        exit 1
      fi
    fi
  done

  return 0
}

system_upgrade() {
  if [ ! "$(sudo pacman -S --sysupgrade --refresh --noconfirm)" ]; then
    echo -e "\n\e[$red System upgrade failed\e[$default"
    exit 1
  else
    # shellcheck disable=SC2154
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
