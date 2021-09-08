#! /bin/env bash

##--------------------------- Utility Functions ------------------------##

# install will install a package or group of packages using a common set of options.
# All packages should be installed using this function to ensure testability and
# uniformity.
package_install() {
  local pkgs=("$@")
  # local pkg_list=("pacman -Qe")

  for t in "${pkgs[@]}"; do
    if [ ! "$(pacman -Q | grep "$t")" ]; then

      if [ ! "$(sudo pacman -S --noconfirm "$t")" ]; then
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

# https://stackoverflow.com/questions/5014632/how-can-i-parse-a-yaml-file-from-a-linux-shell-script
parse_yaml() {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}