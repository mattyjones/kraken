#! /bin/bash

// This is nothing more than a basic awesomewm setup w/ no frills 
// Add in the bits from parrothtb and kracken that give me a normal install

 `tar -xf`
- `vagrant:vagrant`
- `pacman -S lightdm awesome xorg-server org-xinit`

sudo  `pacman -S lightdm awesome xorg-server org-xinit`
sudo - `cp /etc/X11/xinit/xinitrc /home/<USER>/.xinitrc`
sudo - `pacman -S neovim`
sudo - `pacman -S fontconfig ttf-firacode`
sudo - `sudo fc-cache`
sudo - `pacman alacritty tmux`
sudo - `pacman -S open-vm-tools`
sudo - `systemctl enable vmtoolsd.service`
sudo - `systemctl enable vmware-vmblock-fuse.service`
sudo mkinitcpio -P
sudo pacman -Syyu

sudo pacman -S vi (visudo) (enable the wheel directory)
sudo useradd matt
sudo passwd matt
sudo groupadd -a -G wheel
sudo mkdir -p /home/matt
sudo cp -R /home/vagrant/ .* /home/matt/
sudo chown -R matt:matt /home/matt
sudo mkdir -p /mnt/VM_Data
# sudo vmhgfs-fuse -o allow_other -o auto_unmount .host:/<shared_folder> <shared folders root directory>
/etc/fstab
.host:/<shared_folder> <shared folders root directory> fuse.vmhgfs-fuse nofail,allow_other 0 0

echo ".host:VM_Data /mnt/sharefs fuse.vmhgfs-fuse allow_other 0 0" >> /etc/fstab

/etc/systemd/system/<shared folders root directory>-<shared_folder>.service
[Unit]
Description=Load VMware shared folders
Requires=vmware-vmblock-fuse.service
After=vmware-vmblock-fuse.service
ConditionPathExists=.host:/<shared_folder>
ConditionVirtualization=vmware

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/vmhgfs-fuse -o allow_other -o auto_unmount .host:/<shared_folder> <shared folders root directory>

[Install]
WantedBy=multi-user.target

systemctl enable VM_Data.service

need cut and paste from host to vm


# bash profile to startx x at login
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec startx
fi

#! /bin/env bash
#
#  kraken
#
# AUTHOR: Matt Jones
#
# DESCRIPTION:
#    Kraken is a semi-automated, opinionated environment configuration tool.
#    Application and tool specific configurations are easy to modify. All tools
#    are built and installed as isolated as possible to ensure modularity and
#    user specific tastes.
#
# OUTPUT:
#    plain-text
#
# PLATFORMS:
#    OSX, MacOS
#
# DEPENDENCIES:
#    bash
#
# USAGE:
#    scripts/configure_osx
#
# NOTES:
#
# LICENSE:
#    MIT
#

##---------------------- Initialize config script --------------------##

# This gathers basic info, performs any setup configurations and makes sure any script dependencies
# are met.
initalize() {
  echo "Starting installation..."
  cwd=$(pwd)

  if [ -n "$(curl -v)" ]; then
    echo "curl is not installed."
    echo "curl should of been installed by default"
    exit 1
  fi

  # Ask for the administrator password upfront
  sudo -v

  # Keep-alive: update existing `sudo` time stamp until we have finished
  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done 2>/dev/null &

  # Make sure the necessary directorys exist and if not create them.
  if [[ -d "$HOME/.config" ]]; then
    echo "Creating the user .config directory"
    mkdir "$HOME/.config"
  fi

  return 0
}

install_updates() {
  if ! [ "$(sudo softwareupdate --install -all)" ]; then
    echo "Software updates failed to be installed"
  fi

  return 0
}

##---------------------- Configure TMUX --------------------##

# I use tmux as my primary terminal inface and run
# it on terminal startup so it is always ready for me.
configure_tmux() {

  echo "Configuring tmux..."
  ln -s "$cwd/tmux/_tmux" "$HOME/.tmux"
  ln -s "$cwd/tmux/_tmux.conf" "$HOME/.tmux.conf"

  return 0
}

##---------------------- Shell Configuration --------------------##

# Set the colors I want. Not always necessary to do this, it is very terminal
# and OS specific. I am just in the habit of doing it.
install_dircolors() {
  if [ -f "$HOME/.dir_colors" ]; then
    echo "dir_colors already installed. Skipping."
  else
    ln -s "$cwd/shell/_dir_colors" "$HOME/.dir_colors"
  fi

  return 0
}

# Install and provide a baseline configuration for oh-my-zsh that a user can then configure
# to my hearts content for the next four hours. I don't bother with installing zsh and setting
# it as the default terminal as that is the standard shell in MacOS.
configure_oh_my_zsh() {
  # TODO remove the config backup when we are done

  # Check to see if it is already installed
  if [ -f "$HOME/.oh-my-zsh/" ]; then
    echo "oh-my-zsh is already installed. Skipping installation"
    echo "Updating oh-my-zsh..."
    omz update
  else
    # Remove any existing configuration just in case and then do an install
    rm -rf "$HOME/.oh-my-zsh/"
    curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
    rm "$HOME/.zshrc.pre*" # Remove any backup files that were created
    rm "$HOME/.zshrc" # Remove the stock zshrc file so we can link the custom one
  fi

  # Add any updated themes, plugins, etc that are needed
  echo "Installing zsh plugins..."

  return 0
}

# Drop my specific dotfiles onto the box
configure_shell_env() {
  ln -s "$cwd/shell/_alias" "$HOME/.alias"
  ln -s "$cwd/shell/_exports" "$HOME/.exports"
  ln -s "$cwd/shell/_zshrc" "$HOME/.zshrc"
  ln -s "$cwd/shell/_functions" "$HOME/.functions"
  ln -s "$cwd/shell/_grep" "$HOME/.grep"

  if [ -f "$HOME/.secrets" ]; then
    echo "Base secrets file is already installed. Skipping"
  else
    cp "$cwd/shell/_secrets" "$HOME/.secrets"
  fi

  return 0
}

# Configure Starship for my development prompt
configure_starship() {
  ln -s "$cwd/starship/starship.toml" "$HOME/.config/starship.toml"

  return 0
}

# Install the root  editorconfig file
install_editorconfig() {
  ln -s "$cwd/editorconfig/_editorconfig" "$HOME/.editorconfig"

  return 0
}

##---------------------- Neovim Configuration --------------------##

# Configure Neovim
configure_nvim() {
  # TODO we should be installing this, not just copying it over but hey
  # if the shoe fits

  # Check to see if it is already installed
  if [ -f "$HOME/.config/nvim/" ]; then
    echo "Neovim is already configured."
  else
    # Make sure an existing config is gone to avoid pollution
    rm -rf "$HOME/.config/nvim/"
    ln -s "$cwd/nvim/nvim" "$HOME/.config/"
  fi
  return 0
}

##---------------------- Terminal Configurations --------------------##

# Configure hyper as a terminal if I am installing it. This is a Node.js based
# terminal configured via js and css. It is fancy but I have seen perf issues and
# something about it just bugs me so it is only here for legacy reasons.
configure_hyper() {
  if [[ "$(which hyper)" ]]; then

    # Removing the default setup
    rm -rf ~/.hyper*

    echo "Configuring the hyper.js environment"
    ln -s "$cwd/hyper/_hyper.js" "$HOME/.hyper.js"
    ln -s "$cwd/hyper/_hyper_plugins" "$Home/.hyper_plugins"
  fi

  return 0
}

# Alacritty is my current terminal emulator for all platforms. It is
# very fast, easy to configure, and has all the options I need. When it starts
# I launch tmux automagically to allow me the flexibility I need. See the
# config file for more details.
configure_alacritty() {
  ln -s "$cwd/alacritty/_alacritty.yml" "$HOME/.alacritty.yml"

  return 0
}

##---------------------- Git Configuration --------------------##

# Configure my git environment. Do not enable this unless you really know what
# you are doing. No, I'm serious. I have a lot of tweaks and touches in here
# due to having multiple profiles and working on many different projects.
configure_git() {

  if [ ! -f "$HOME/.gitconfig" ]; then
    echo "Installing a global git configuration file to my home directory."
    ln -s "$cwd/git/_gitconfig" "$HOME/.gitconfig"
  fi

  return 0
}

##---------------------- Ruby Installation --------------------##

# Install a known good version of 3.x ruby. This does not replace the system ruby
# and uses ruby-install for the installation and chruby for auto-switching. Both of these
# are installed via Homebrew.
# If you change the version of Ruby you install ensure that you also update
# the zshrc file and tell chruby which one to use as your default.
# TODO Check to see if it is already installed and if so delete it
install_ruby() {

  if [[ "$(which ruby-install)" ]]; then
    echo "Installing the latest 3.x Ruby with ruby-install. This may take about 5m"
    ruby-install ruby 3
  else
    echo "You need to have 'ruby-install' installed or modify this function"
  fi

# TODO Install default rubocop file
# https://raw.githubusercontent.com/rubocop/rubocop/master/config/default.yml

# TODO Create a general gemfile for bundler

  return 0
}

##--------------------------- Main -------------------------##
main() {

  # Sanity check the environment and box
  initalize

  # This is very expermental, enable at your own peril. I suggest
  # creating a backup first
  # Configure MacOS specific bits
  # configure_osx

  # Install as many of the packages I need as I can
  install_homebrew

  # Setup my terminals
  configure_alacritty
  configure_tmux

  # Setup my shell environment
  configure_oh_my_zsh
  configure_shell_env
  install_dircolors

  # Setup development specific bits
  configure_starship
  configure_git
  # install_cpan
  install_ruby
  install_editorconfig
  configure_wraith

  # Configure my editors
  configure_nvim

  # Misc bits and pieces
  # configure_gpg

  echo "All done. Go be a creepy human"
  exit 0

}

# TODO tests?

main

# Install and provide a baseline configuration for oh-my-zsh that a user can then configure
# to their hearts content for the next four hours.
install_oh_my_zsh() {
  local ans=""

  # Check to see if ZSH is already installed
  if [ ! "$(which "zsh")" ]; then
    echo "ZSH is already installed. Do you wish to install it? This will backup and replace your current configuration [Y/n]"
    read -r ans
    if [[ $ans == "n" ]]; then
      echo "Skipping ZSH installation"
    else
      echo "Installing ZSH"
      su "$script_user" -c "bash -c $(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) "" --unattended"
    fi
  fi

# Do we want to set it as the default shell
  local ans=""
  echo "Do you want to activate ZSH now and make it your default shell? [Y/n] A reboot should be done when this script is complete"

  read -r ans
  if [[ $ans == "" ]] || [[ $ans == "Y" ]]; then
    enable_zsh
  fi
}

enable_zsh() {
# Set ZSH as the default shell
# There is a lot of pam noise and sed going on in here. It is simply due to the fact we are running
# the script as the root user yet we want to change the shell of the user that invoked it.

# TODO notifications about this and that it worked
# TODO is it already the shell

sed -i.bak '/auth       required   pam_shells.so/a auth       sufficient   pam_wheel.so trust group=chsh' /etc/pam.d/chsh
groupadd chsh
usermod -a -G chsh "$script_user"
su "$script_user" -c "chsh -s $(which zsh)"
gpasswd -d "$script_user" chsh
groupdel chsh
sed -i.bak '/auth       sufficient   pam_wheel.so trust group=chsh/d' /etc/pam.d/chsh

reboot=true
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

# I prefer this to any other program, including conky. That is mostly from
# a performance point of view. There is nothing stopping you from running both
# as conky is cool eye candy.
#setup_polybar() {
#local polybar_config_dir="/home/$script_user/.config/polybar"
#local i3_config_dir="/home/$script_user/.config/i3"
#
## pull in the fonts for the example
#
#  # copy the example
#  mkdir $polybar_config_dir # TODO check to see if this is there
#  cp /usr/share/doc/polybar/config $polybar_config_dir
#  apt-get install -y unifont
#  # TODO make sure we are in /tmp
#  git clone https://github.com/stark/siji && cd siji
#  su "$script_user" -c "./install.sh"
#  dpkg-reconfigure fontconfig-config # TODO can this be automated?
#  chmod +x $polybar_config_dir/launch.sh
#  rm -rf /tmp/siji # Always hardcode this to be safe
#}
#
#setup_rofi() {
#  mkdir /home/"$script_user"/.config/rofi
#  # need to set the theme and configuration
#  #----------START HERE------------#
#
#}
#
#setup_i3() {
#  # remove te existing config so we can start off clean
#
#  config_dir="/home/"$script_user"/.config/i3/config"
#  rm "$config_dir"/config
#  echo "exec --no-startup-id vmware-user-suid-wrapper" >> "$config_dir"/config
#
#  # set up an example polybar. A parrot specific one is out of scope
#  # for stage 1
#  setup_polybar()
#
#}


main() {
###--------------------------------System Updates--------------------------------------###

  # TODO Check for sudo before we do anything

  if [[ $(id) -ne 0 ]]; then
    echo "Sudo is required"
  fi

  # prep work
  apt-get update
  check_tools "${required_tools[@]}"
  cd /tmp || echo "The update failed" | exit

  echo "Do you want to upgrade the system (this may take a while)? [Y/n]"
  read -r ans

  if [[ $ans == "Y" ]]; then
    apt-get full-upgrade
  else
    echo "The system will not be upgraded"
  fi

###--------------------------------Package Installation--------------------------------------###

  # Install Package Groups
  # The counter is here and reset everytime to provide a short circuit in the event
  # a user gets stuck in a loop of listing packages or trying to install them
  counter=0
  install_pkg_grps "Development" "${development_pkgs[@]}"

  counter=0
  install_pkg_grps "Windows" "${windows_pkgs[@]}"

  counter=0
  install_pkg_grps "Web" "${web_pkgs[@]}"

  counter=0
  install_pkg_grps "Tool" "${tools_pkgs[@]}"

  counter=0
  install_pkg_grps "Host/VM Sharing" "${share_pkgs[@]}"

  counter=0
  install_pkg_grps "Pentest" "${pentest_pkgs[@]}"

  counter=0
  install_pkg_grps "i3" "${i3_pkgs[@]}"

  # counter=0
  # install_pkg_grps "Security" "${security_pkgs[@]}"

  counter=0
  install_pkg_grps "Network" "${network_pkgs[@]}"

  install_bat

# TODO check to make sure the version < 1.0.6
  install_masscan

###--------------------------------Shell Installation and Configuration--------------------------------------###


  install_oh_my_zsh


###--------------------------------System Configurations-------------------------------------###

  create_share

}

main

cleanup


# TODO fix masscan build error
# TODO Fix masscan directory error
# TODO capture return values
# TODO catch warnings
# TODO colored output
# TODO make secure
# TODO quit output
# TODO capture error output and STDERR
# TODO make secure
# TODO quit output
# TODO install oh my zsh
# TODO install airline for vim and terminal
# TODO install nord
# TODO install nord tmux theme
# TODO install zsh-dircolors-nord
# TODO install lightline for nvim
# TODO install nord for nvim
# TODO configure nvim

# Editors (these are optional)
development_pkgs=("neovim" "vscodium")

# Various tools I find useful and helpful (these are optional)
tools_pkgs=("jq" "lnav" "tmux" "zsh" "bat")

# packages to allow sharing data, including cut/paste with the host OS (these are optional)
share_pkgs=("open-vm-tools" "open-vm-tools-desktop")

# i3 specific packages needed to bring up a simple i3 setup
i3_pkgs=( "lightdm" "xfce4-terminal"  "i3" "feh" "polybar" "dunst" "rofi" "ranger" "irssi")

# When removing Gnome and Mate networking packages are removed as well, these will be needed
# for basic connections
network_pkgs=("network-manager" "openconnect")

# pks to remove from a mate install (these are optional)
#remove_pkgs=("gnome*" "mate*")

# The VM share dir
share_dir="sharefs"

# Tools required to run the script. These should already be installed
required_tools=("curl" "wget")

# Set this to true if we need to do a reboot, specifically for the shell change
reboot=false

sudo systemctl enable lightdm.service

sudo pacman -S lightdm-gtk-greeter

init=/bin/bash (single user)
systemd.unit=multi-user.target (runlevel 3)
systemd.unit=rescue.target (runkevel 1)

pacman -Syyu

do something cool with the login screen greeter
