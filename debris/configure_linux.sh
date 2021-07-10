#! /usr/bin/env bash

#
# This requires ParrotOS Security Mate
# It produces a tailored setup for i3 (see proj ct README for details)
#

###--------------------------------Global Declarations--------------------------------------###

# Some of these may already be installed, if so they will  not be re-installed or upgraded.

# packages to install after stripping everything else away
awesomewm_pkgs=( "lightdm" "awesome" "feh" "polybar" "dunst" "rofi" "i3lock" "scrot")

# general packages
general_pkgs=( "jq" "lnav" "firefox" "tmux" "neovim" "zsh" "ranger" "wine" "irssi" "openconnect" "vscodium" "open-vm-tools" "open-vm-tools-desktop" "git")

# vm share dir
share_dir="sharefs"

#versions
bat_ver="0.17.1"

script_user="$(logname)"
# TODO Check for sudo before we do anything

# Pentest and CTF specific packages (these are optional)
pentest_pkgs=( "exploitdb" "masscan")

# Base firefox (these are optional)
web_pkgs=("firefox")

# Wine, fo use specific reverse engineering tools or doing ctf work (these are optional)
windows_pkgs=("wine")

# TODO how can I bring down binary ninja
# Editors (these are optional)
development_pkgs=("neovim" "vscodium")

# Various tools I find useful and helpful (these are optional)
tools_pkgs=("jq" "lnav" "tmux" "zsh")


configure_awesome() {

  # create the directory
  mkdir -p ~/.config/awesome/

  # copy the stock config
  cp /etc/xdg/awesome/rc.lua ~/.config/awesome/

  # TODO get rid of the title bar for the apps

  # need to create ~/Pictures for scrot

}

install_rust() {
  # how can this be automated so I don't have to type yes
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

  # need to bouce the shell to get the env variables updated
}

install_alacritty() {
  # need git and rust
  cd ~/bin
  git clone https://github.com/alacritty/alacritty.git
  cd alacritty

  cargo build --release

  apt-get install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev python3

# ensure this comes back w/ no errors
infocmp alacritty

# if it has errors
tic -xe alacritty,alacritty-direct extra/alacritty.info

# actual install and desktop files
sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database



# install manpages
sudo mkdir -p /usr/local/share/man/man1
gzip -c extra/alacritty.man | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null


# zsh shell completions
mkdir -p ${ZDOTDIR:-~}/.zsh_functions
echo 'fpath+=${ZDOTDIR:-~}/.zsh_functions' >> ${ZDOTDIR:-~}/.zshrc
cp extra/completions/_alacritty ${ZDOTDIR:-~}/.zsh_functions/_alacritty

}

configure_lightdm() {

  # change the greeter config
  /etc/lightdm/lightdm-gtk-greeter.conf

  # change the lightdm config
   /etc/lightdm/lightdm.conf

  # dialog box to set lightdm as the default
  dpkg-reconfigure lightdm

# TODO doing this manually did not seem to work
  # file to change the display-manger
#  vim /etc/X11/default-display-manager

  # to do the search and replace
 # sed -i 's/old-text/new-text/g' input.txt
}

configure_user() {
  # add the user to the sudo group (unrestricted but will require a password
  usermod -a -G sudo geek
}


wget https://gist.github.com/mattyjones/17fa10e0c67c86e8407668a7ccaf36a0/raw/ffe8d3533a56041e77415a306c276647e1059881/debian_security_install.sh