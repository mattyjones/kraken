#! /bin/env bash
#
#  Kraken
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
#    Arch Linux
#
# DEPENDENCIES:
#    bash
#
# USAGE:
#    scripts/install_arch_base.sh
#
# NOTES:
#
# LICENSE:
#    MIT
#

##--------------------------- Prework ----------------------------------##

# 1. https://gitlab.archlinux.org/archlinux/arch-boxes/-/jobs/32554/artifacts/browse/output
# 2. `tar -xf <image>
# 3. Import the box into vmware fusion
# 4. Boot the box and login w/ vagrant:vagrant
# 5. `sudo su -`
# 6. `adduser -d /home/$USER -G wheel -m $USER`
# 8. `passwd $USER $PASSWORD`
# 9. `cp -R /home/vagrant/ .* /home/$USER/`
# 10. `chown -R $USER:$USER /home/$USER`
# 11. pacman -S --noconfirm vi
# 12. Enable the wheel group in sudoers
# 13. `groupadd -a -G wheel`
# 14. log out and login in as $USER


##----------------------- Initialize config script ---------------------##

# Initialize gathers basic info, performs any setup configurations and makes
# sure any script dependencies are met. It will not check to see what it is
# running as or if the user is setup correctly. Don't be lazy, don't run
# this as root.
initialize() {
  echo "Starting installation..."
  cwd=$(pwd)

  # Ask for the administrator password upfront
  sudo -v

  # Keep-alive: update existing `sudo` time stamp until we have finished
  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done 2>/dev/null &

  system_upgrade

  if [ -n "$(curl -v)" ]; then
    echo "Installing curl"
    package_install curl
  fi

  if [ -n "$(wget -v)" ]; then
    echo "Installing wget"
    package_install wget
  fi

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

install_editors() {
  local pkgs=("neovim")
}


##---------------------- Terminal Configurations --------------------##

# Alacritty is my current terminal emulator for all platforms. It is
# very fast, easy to configure, and has all the options I need. When it starts
# I launch tmux automagically to allow me the flexibility I need. See the
# config file for more details.
configure_alacritty() {
    local pkgs=("alacritty")
  ln -s "$cwd/alacritty/_alacritty.yml" "$HOME/.alacritty.yml"

  return 0
}

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


##---------------------- Shell Configuration --------------------##


# Install and provide a baseline configuration for oh-my-zsh that a user can then configure
# to my hearts content for the next four hours. I don't bother with installing zsh and setting
# it as the default terminal as that is the standard shell in MacOS.
configure_oh_my_zsh() {
    local pkgs=("zsh")
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
    rm "$HOME/.zshrc"      # Remove the stock zshrc file so we can link the custom one
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








##---------------------- Configure TMUX --------------------##

# I use tmux as my primary terminal inface and run
# it on terminal startup so it is always ready for me.
configure_tmux() {
    local pkgs=("tmux")

  echo "Configuring tmux..."
  ln -s "$cwd/tmux/_tmux" "$HOME/.tmux"
  ln -s "$cwd/tmux/_tmux.conf" "$HOME/.tmux.conf"

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


# TODO fix masscan build error
# TODO Fix masscan directory error
# TODO capture return values
# TODO catch warnings
# TODO colored output
# TODO make secure
# TODO quit output
# TODO capture error output and STDERR
# TODO install airline for vim and terminal
# TODO install nord
# TODO install nord tmux theme
# TODO install zsh-dircolors-nord
# TODO install lightline for nvim
# TODO install nord for nvim
# TODO configure nvim

# Various tools I find useful and helpful (these are optional)
tools_pkgs=("jq" "bat" "rsync" "gvfs")

network_pkgs=("network-manager" "openconnect")

# The VM share dir
share_dir="sharefs"

# Set this to true if we need to do a reboot, specifically for the shell change
reboot=false
