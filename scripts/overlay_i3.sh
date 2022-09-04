#! /usr/bin/env bash

#
# This requires ParrotOS Security Mate
# It produces a Stage 1 setup (overlay i3 on top of Mate) and is very opinionated
# at this point.
#

# Packages to install for i3, if you are removing the existing desktop environment
# you will need to install additional packages, including a terminal emulator,
# file browser, network management tool, notification manager, etc. You should
# do this before rebooting the machine as it will become much harder after a reboot.
i3_pkgs=( "i3" "polybar" )

# We need as the script runs as sudo and everything would be installed from root's
# point off view. This pulls in the user that is currently logged in. 
script_user="$(logname)"

# Check if a package listed above is installed, if it is not then install it. You 
# should do this to avoid having the package listed as manually installed.
check_apt() {
pkgs=("$@")
for p in "${pkgs[@]}";
do 
if [ ! "$(dpkg -l "$p")" ]
then
        echo "$p is not installed."
        echo "Installing $p"
        apt-get install -y $p    
fi
done
}

# I prefer this to any other program, including conky. That is mostly from
# a performance point of view. There is nothing stopping you from running both
# as conky is cool eye candy.
setup_polybar() {
local polybar_config_dir="/home/$script_user/.config/polybar"
local i3_config_dir="/home/$script_user/.config/i3"

  # copy the example
  mkdir $polybar_config_dir
  cp /usr/share/doc/polybar/config $polybar_config_dir

  # pull in the fonts for the example
  apt-get install -y unifont
  
  git clone https://github.com/stark/siji && cd siji
  su "$script_user" -c "./install.sh"
  dpkg-reconfigure fontconfig-config
  chmod +x $polybar_config_dir/launch.sh  
  rm -rf /tmp/siji
}

setup_i3() {

  # remove te existing config so we can start off clean
  config_dir="/home/"$script_user"/.config/i3/config"
  rm "$config_dir"/config

}

main() {

apt-get update
cd /tmp

# Check and installl needed packages
check_apt "${i3_pkgs[@]}"

setup_i3

setup_polybar

}

main