#! /bin/bash

# setup script for Kali

###--------------------------------Global Declarations--------------------------------------###

# Pentesting apt packages
htb_pkgs=( "exploitdb" "gobuster" "nikto")

# General apt packages
# Some of these may already be installed, if so they will not be re-installed or upgraded
general_pkgs=( "jq" "lnav" "tmux" "neovim" "zsh" "open-vm-tools" "open-vm-tools-desktop")

# The VM share dir
share_dir="sharefs"

# Pinned versions
bat_ver="0.17.1"

# User that is running the script via sudo. This is necessary to ensure the 
# correct permissions are created and files are put in the proper home 
# directory.
script_user="kali"

# Tools required to run the script. These should already be installed
required_tools=("curl" "wget")

###--------------------------------Function Declarations--------------------------------------###

check_tools() {
tools=("$@")
for t in "${tools[@]}";
do 
if [ ! "$(which $t)" ]
then
        echo "$t is not installed."
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
        echo "Installing $p"
        apt-get install -y $p    
fi
done
}

install_oh_my_zsh() {
# Install oh-my-zsh and configure it
# if the want to change the shell and switch to it now
$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) "" --unattended
}

enable_zsh() {
# Enable zsh as the default shell
sed -i.bak '/auth       required   pam_shells.so/a auth       sufficient   pam_wheel.so trust group=chsh' /etc/pam.d/chsh
groupadd chsh
usermod -a -G chsh $script_user
su $script_user -c "chsh -s $(which zsh)"
gpasswd -d $script_user chsh
groupdel chsh
sed -i.bak '/auth       sufficient   pam_wheel.so trust group=chsh/d' /etc/pam.d/chsh
}

install_bat() {
# Installing bat
pkg=$(echo "https://github.com/sharkdp/bat/releases/download/v"$bat_ver"/bat_"$bat_ver"_amd64.deb" | rev | cut -d'/' -f 1 | rev)

wget "https://github.com/sharkdp/bat/releases/download/v"$bat_ver"/bat_"$bat_ver"_amd64.deb"
dpkg -i $pkg
rm $pkg

}

build_directories() {
        # Install directory structure
        mkdir -p ~/Desktop/Exam/{scripts,config,scratch}
        mkdir -p ~/Desktop/Labs/{scripts,config,scratch}
}

create_share() {
# Create the filesystem
# check if the dir already exists 
if [ ! -d "$share_dir" ]
then
   echo "$share_dir does not exist, creating it"
   mkdir /mnt/$share_dir
else
   echo "The directory already exists"
fi

# make sure the mount point exists
# Mount the filesystem for usage in this current session
if grep -qs '/mnt/sharefs ' /proc/mounts; then
    echo "The share has already been mounted"
else
    sudo mount -t fuse.vmhgfs-fuse .host:/ /mnt/sharefs -o allow_other
fi

# Add to /etc/fstab for persistence
# check if it already exists
share=$(grep "/mnt/$share_dir" /etc/fstab)

if [[ $share == "" ]]; then
    echo ".host:/ /mnt/sharefs fuse.vmhgfs-fuse allow_other 0 0" >> /etc/fstab
else
    echo "This has already been set to auto mount"
fi

}

install_masscan() {
wget https://github.com/robertdavidgraham/masscan/archive/master.zip
unzip master.zip && cd masscan-master
make && sudo make install
sudo cp ./bin/masscan /usr/bin
}


main() {
###--------------------------------Package Instalations--------------------------------------###


# prep work
check_tools "${required_tools[@]}"
apt-get update
cd /tmp

# Check and installl needed packages
check_apt "${htb_pkgs[@]}"
check_apt "${general_pkgs[@]}"

install_bat


install_masscan


###--------------------------------System Configurations-------------------------------------###

create_share

}

main
