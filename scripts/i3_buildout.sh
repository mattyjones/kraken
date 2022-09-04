#! /usr/bin/env bash

#
# This requires ParrotOS Security Mate
# It produces a Stage 1 setup (see project README for details)
#

###--------------------------------Global Declarations--------------------------------------###

# packages to install after stripping everything else away
i3_pkgs=("network-manager" "lightdm" "xfce4-terminal"  "i3" "feh" "polybar" "dunst" "rofi")

# additional security packages
security_pkgs=( "exploitdb" "openvpn" "strongswan")

# general packages
general_pkgs=( "jq" "lnav" "firefox" "tmux" "neovim" "zsh" "ranger" "wine" "irssi" "openconnect" "vscodium" "open-vm-tools" "open-vm-tools-desktop")

# pks to remove from a mate install
remove_pkgs=("gnome*" "mate*")

# vm share dir
share_dir="sharefs"

#versions
bat_ver="0.17.1"

script_user="$(logname)"
# TODO Check for sudo before we do anything

required_tools=("curl" "wget" "zsh")

###--------------------------------Function Declarations--------------------------------------###

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

setup_polybar() {
local polybar_config_dir="/home/$script_user/.config/polybar"
local i3_config_dir="/home/$script_user/.config/i3"

# pull in the fonts for the example

  # copy the example
  mkdir $polybar_config_dir # TODO check to see if this is there
  cp /usr/share/doc/polybar/config $polybar_config_dir
  apt-get install -y unifont
  # TODO make sure we are in /tmp
  git clone https://github.com/stark/siji && cd siji
  su "$script_user" -c "./install.sh"
  dpkg-reconfigure fontconfig-config # TODO can this be automated?
  chmod +x $polybar_config_dir/launch.sh  
  rm -rf /tmp/siji # Always hardcode this to be safe
}

setup_rofi() {
  mkdir /home/"$script_user"/.config/rofi
  # need to set the theme and configuration
  #----------START HERE------------#

}

setup_i3() {
  # remove te existing config so we can start off clean

  config_dir="/home/"$script_user"/.config/i3/config"
  rm "$config_dir"/config
  echo "exec --no-startup-id vmware-user-suid-wrapper" >> "$config_dir"/config

  # set up an example polybar. A parrot specific one is out of scope
  # for stage 1
  setup_polybar()



}

###--------------------------------Package Instalations--------------------------------------###

# prep work
check_tools "${required_tools[@]}"
apt-get update
cd /tmp
#apt-get full-upgrade

# Check and installl needed packages
check_apt "${i3_pkgs[@]}"
check_apt "${general_pkgs[@]}"
check_apt "${security_pkgs[@]}"


# cleanup
# do you want to autoremove packages
#apt-get autoremove -y --purge



# Create the filesystem
# check if the dir already exists 
if [ -d "$share_dir" ]
then
   echo "$share_dir does not exist, creating it"
   mkdir /mnt/$share_dir
else
   echo "The directory already exists"
fi



# make sure the mount point exists
# Mount the filesystem for usage in this current session
if grep -qs "/mnt/$share_dir " /proc/mounts; then
    echo "The share has already been mounted"
else
    sudo mount -t fuse.vmhgfs-fuse .host:/ "/mnt/$share_dir" -o allow_other
fi



# Add to /etc/fstab for persistence
# check if it already exists
share=$(grep "/mnt/$share_dir" /etc/fstab)

if [[ $share == "" ]]; then
    echo ".host:/ "/mnt/$share_dir" fuse.vmhgfs-fuse allow_other 0 0" >> /etc/fstab
else
    echo "This has already been set to auto mount"
fi

# Install oh-my-zsh and configure it
# if the want to change the shell and switch to it now
su $script_user -c "bash -c $(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) "" --unattended"
#su $script_user -c "bash -c $(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo "Do you want to remove your old shells automatically?"


# Installing bat
pkg=$(echo "https://github.com/sharkdp/bat/releases/download/v"$bat_ver"/bat_"$bat_ver"_amd64.deb" | rev | cut -d'/' -f 1 | rev)

wget "https://github.com/sharkdp/bat/releases/download/v"$bat_ver"/bat_"$bat_ver"_amd64.deb"
dpkg -i $pkg
rm $pkg

# we need to set zsh as the shell
# notifications about this and that it worked
# ask if they want it
# is it already the shell
sed -i.bak '/auth       required   pam_shells.so/a auth       sufficient   pam_wheel.so trust group=chsh' /etc/pam.d/chsh
groupadd chsh
usermod -a -G chsh $script_user
su $script_user -c "chsh -s $(which zsh)"
gpasswd -d $script_user chsh
groupdel chsh
sed -i.bak '/auth       sufficient   pam_wheel.so trust group=chsh/d' /etc/pam.d/chsh

###--------------------------------System Configurations-------------------------------------###




#need to do some i3 work now


# reboot so things can take effect
# should ask to do this
#init 6


# make sure zsh is install
# do we want to set zsh as the shell
# check for needed tools and install them
# catch warnings
# colored output
# make secure
# use functions
# quit output
# capture error output and STDERR

