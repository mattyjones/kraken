#!/bin/bash

blackarch-config-bash
blackarch-config-cursor
blackarch-config-gtk
blackarch-config-icons
blackarch-config-lxdm
blackarch-config-xfce
blackarch-config-x11
blackarch-config-zsh

sudo pacman -S firefox dirbuster ttf-droid

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

sudo pacman -S blackarch-artwork blackarch-config-zsh

cp -a /usr/share/blackarch/config/zsh/zshrc ~/.zshrc

need to merge the blackarch config and mine

still need to build my own masscan (can I push this back to blackarch)

need open vpn for HTB

cp -a /usr/share/blackarch/config/x11/xprofile /etc/xprofile
cp -a /usr/share/blackarch/config/x11/Xresources ~/.Xresources
cp -a /usr/share/blackarch/config/x11/Xdefaults ~/.Xdefaults

vscode

whatweb
gobuster
hashcat
cewl
seclists
gnu-netcat

change the grub menu

change the login screen

edit /etc/default/grub
add /usr/share/blackarch/artwork/grub/splash2.png

cp wallpaper-NINJARCH-code.png /usr/share/pixmaps

install openvpn

grub-mkconfig -o /boot/grub/grub.cfg

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

