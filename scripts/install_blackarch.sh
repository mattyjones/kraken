#!/bin/bash
#
# Brief description of your script
# Copyright 2021 matt

function main() {
  :
}

main "$@"

#! /bin/bash

blackarch-config-bash
blackarch-config-cursor
blackarch-config-gtk
blackarch-config-icons
blackarch-config-lxdm
blackarch-config-xfce
blackarch-config-x11
blackarch-config-zsh

sudo pacman -S firefox dirbuster ttf-droid

// Add in the bits from parrothtb and kracken that give me a pentest install

# Run https://blackarch.org/strap.sh as root and follow the instructions.
$ curl -O https://blackarch.org/strap.sh
# Verify the SHA1 sum
$ echo 46f035c31d758c077cce8f16cf9381e8def937bb strap.sh | sha1sum -c
# Set execute bit
$ chmod +x strap.sh
# Run strap.sh
$ sudo ./strap.sh
# Enable multilib following https://wiki.archlinux.org/index.php/Official_repositories#Enabling_multilib and run:
$ sudo pacman -Syu

pacman -S blackarch-config-awesome

cp /usr/share/blackarch/config/awesome/etc/xdg/awesome/rc.lua.blackarch /etc/xdg/awesome/rc.lua
cp -a /usr/share/blackarch/config/awesome/usr/share/awesome/themes/blackarch /usr/share/awesome/themes/
cp /etc/xdg/awesome/rc.lua ~/.config/awesome/rc.lua

# need to redo the menu in the stock config to be dynamic?

sudo pacman -S blackarch-artwork blackarch-config-zsh

cp -a /usr/share/blackarch/config/zsh/zshrc ~/.zshrc

need to merge the blackarch config and mine

blackarch rc.lua has the menu

create my own menu in rc.lua and move it to a different file

still need to build my own masscan (can I push this back to blackarch)

need open vpn for HTB

cp -a /usr/share/blackarch/config/x11/xprofile /etc/xprofile
cp -a /usr/share/blackarch/config/x11/Xresources ~/.Xresources
cp -a /usr/share/blackarch/config/x11/Xdefaults ~/.Xdefaults


pacman -S archlinux-xdg-menu blackarch-menus
xdg_menu --format awesome

vscode

whatweb
gobuster
hashcat
cewl
seclists
gnu-netcat

dirbuster (requires java) (did not install, use gobuster)


change the grub menu

change the login screen

edit /etc/default/grub
add /usr/share/blackarch/artwork/grub/splash2.png

cp wallpaper-NINJARCH-code.png /usr/share/pixmaps

sudo nvim /etc/lightdm/lightdm-gtk-greeter.conf

change the Modkey to mod1 (opition)

install openvpn

grub-mkconfig -o /boot/grub/grub.cfg

grab the custom awesome config

https://wiki.archlinux.org/title/awesome#Extensions

install_masscan() {
  # Install a patched version of masscan. The default version has a bug in the wait functionality
  # that causes it to loop indefinitely and cannot not be used in scripts

  echo "Do you wish to update masscan? [Y/n/l]"
  read -r ans
  if [[ $ans == "" ]] || [[ $ans == "Y" ]]; then
    wget https://github.com/robertdavidgraham/masscan/archive/master.zip &> /dev/null
    unzip master.zip && cd masscan-master || echo "masscan package corrupted"

    if [[ $0 -ne 0 ]]; then
      echo "masscan not downloaded correctly"
      return 1
    fi

    make && make install &> /dev/null

    if [[ $0 -ne 0 ]]; then
      echo "masscan was not built and installed correctly"
      return 1
    fi

    cp ./bin/masscan /usr/bin
    return 0

  else
    echo "masscan not updated"
    return 0
  fi
}

create_share() {
# Create the filesystem

  local ans=""
  echo "Would you like to setup sharing and cut/paste between the host and this vm? [Y/n]"

  read -r ans
  if [[ $ans == "" ]] || [[ $ans == "Y" ]]; then

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
    if grep -qs '/mnt/sharefs ' /proc/mounts; then
        echo "The share has already been mounted"
    else
        mount -t fuse.vmhgfs-fuse .host:/ /mnt/sharefs -o allow_other
    fi

    # Add to /etc/fstab for persistence check if it already exists
    local share=""
    share=$(grep "/mnt/$share_dir" /etc/fstab)

    if [[ $share == "" ]]; then
        echo ".host:/ /mnt/sharefs fuse.vmhgfs-fuse allow_other 0 0" >> /etc/fstab
    else
        echo "This has already been set to auto mount"
    fi
    return 0
  else
    echo "Sharing not configured"
    return 0
  fi
}

cleanup() {

  if [[ $reboot == true ]]; then
    echo "Do you want to reboot now? [Y/n]"
    reqd -r ans

    if [[ $ans == "Y" ]]; then
      init 6
    fi
  else
    echo "It is always a good idea to reboot after configuring a new shell"
  fi
}


