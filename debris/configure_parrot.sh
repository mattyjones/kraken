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
#    ParrotOS
#
# DEPENDENCIES:
#    bash
#
# USAGE:
#    scripts/configure_parrot.sh
#
# NOTES:
#
# LICENSE:
#    MIT
#

# TODO Need to check all the links to see if they exist and are pointing to the right place
# TODO Some kind of a user menu
# TODO Respect 80 character limit when possible
# TODO list of vscode extensions
# TODO some sort of jetbrains configs, beyond the cloud

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

  # Make sure the necessary directories exist and if not create them.
  if [[ -d "$HOME/.config" ]]; then
    echo "Creating the user .config directory"
    mkdir "$HOME/.config"
  fi

  if [[ -d "$HOME/.local" ]]; then
     echo "Creating the user .local directory"
     mkdir "$HOME/.local"
  fi

  return 0
}



##---------------------- Configure TMUX --------------------##

# I use tmux as my primary terminal inface and run
# it on terminal startup so it is always ready for me.
configure_tmux() {

  echo "Configuring tmux..."

  # install it
  sudo apt-get install tmux &> /dev/null

  # link my configs
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
  # echo "Installing zsh plugins..."
  # TODO install plugins

  enable_zsh

  return 0
}

enable_zsh() {
# Set ZSH as the default shell
# There is a lot of pam noise and sed going on in here. It is simply due to the fact we are running
# the script as the root user yet we want to change the shell of the user that invoked it.

# TODO notifications about this and that it worked
# TODO is it already the shell

sudo sed -i.bak '/auth       required   pam_shells.so/a auth       sufficient   pam_wheel.so trust group=chsh' /etc/pam.d/chsh
sudo groupadd chsh
sudo usermod -a -G chsh "$script_user"
sudo su "$script_user" -c "chsh -s $(which zsh)"
sudo gpasswd -d "$script_user" chsh
sudo groupdel chsh
sudo sed -i.bak '/auth       sufficient   pam_wheel.so trust group=chsh/d' /etc/pam.d/chsh

reboot=true
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
  wget https://starship.rs/install.sh
  sudo sh install.sh --force
  ln -s "$cwd/starship/starship.toml" "$HOME/.config/starship.toml"

  return 0
}

# Install the root  editorconfig file
install_editorconfig() {
  ln -s "$cwd/editorconfig/_editorconfig" "$HOME/.editorconfig"

  return 0
}

##---------------------- GPG Configuration --------------------##

# TODO Do something with this at some point
configure_gpg() {
  #  ln -s "$cwd/gnupg/gpg-agent.conf $HOME/.gnupg/gpg-agent.conf

  return 0
}

##---------------------- Neovim Configuration --------------------##

# Configure Neovim
configure_nvim() {
  sudo apt-get install neovim &> /dev/null
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

# This is my personal config file for testing and using wraith
# https://github.com/N0MoreSecr3ts/wraith
configure_wraith() {
  mkdir "$HOME/.wraith"
  ln -s "$cwd/wraith/config.yaml" "$HOME/.wraith/config.yaml"

  return 0
}

##---------------------- Terminal Configurations --------------------##

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
  apt-get update
  install_packages
  apt-get purge
  apt-get autoremove

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
