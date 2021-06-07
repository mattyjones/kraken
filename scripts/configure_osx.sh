#! /bin/bash
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
#    OSX, MacOs
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

# TODO need to check all the links to see if they exist and are pointing to the right place
# TODO Some kind of a user menu saying the existing stuff will be removed

##---------------------- Initialize config script --------------------##

# This gathers basic info, performs any setup configurations and makes sure any script dependencies
# are met.

set -e

initalize() {
  cwd=$(pwd)
  user_name=$(logname)

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
  if [[ -d "$HOME"/.config ]]; then
    echo "Creating the baseline config directory"
    mkdir "$HOME"/.config
  fi

  return 0
}

# Bring in XCode tools if needed
install_dev_tools() {
  if [ -n "$(sudo xcode-select -v)" ]; then
    if ! [ "$(sudo xcode-select --install)" ]; then
      echo "Developer tools install failed"
    fi
  else
    echo "XCode developer tools already installed"
  fi

  return 0

}

# TODO Need to capture the return status. Do not run this without some additional
# checks so things don't get borked.

# Install any software updates necessary. Doe not work
# fo OS updates for some reason.
install_updates() {
  if ! [ "$(sudo softwareupdate --install -all)" ]; then
    echo "Software updates failed to be installed"
  fi

  return 0
}

##---------------------- Install Homebrew --------------------##

# We check to see if homebrew is installed and if not then we install it. After it completes
# we install the brewfile and install all programs contained in it.
install_homebrew() {

  echo "Checking homebrew"
  if [ -n "$(brew -v)" ]; then
    echo "Installing Homebrew"
    sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    echo "Homebrew is already installed"
  fi

  install_brewfile

  return 0
}

# Link the Brewfile and install all packages. We also run cleanup after
# to generate a list of debis that should be removed, the actual removal
# is a manual process to provide for a sanity check.
install_brewfile() {
  brew_file="$HOME/Brewfile"

  if [ ! -f "$brew_file" ]; then
    echo "Linking brewfile"
    ln -s "$cwd"/homebrew/Brewfile "$brew_file"
  else
    echo "Brewfile already linked"
  fi

  echo "Updating Homebrew package list"
  if brew update --force >/dev/null; then
    echo "Homebrew was updated successfully"
  else
    echo "'brew update' failed"
    exit 1

  fi

  echo "Upgrading Homebrew package list"
  if brew upgrade >/dev/null; then
    echo "Homebrew was upgraded successfully"
  else
    echo "'brew upgrade' failed"
    exit 1
  fi

  echo "Installing homebrew packages"
  if brew bundle install --file "$brew_file" >/dev/null; then
    echo "All Homebrew packages were installed successfully"
  else
    echo "'brew bundle install' failed"
    exit 1
  fi

  echo "Running a cleanup of Homebrew"
  if brew cleanup >"$HOME"/Desktop/brew_cleanup; then
    echo "Homebrew cleanup list was created successfully"
  else
    echo "'brew cleanup' failed"
    exit 1
  fi

  echo "Homebrew Installation Complete"

  return 0
}

##---------------------- Install TMUX --------------------##

# Install and configure tmux. I use it as my primary terminal inface and run
# it upon terminal startup so it is always ready for me.
install_tmux() {

  echo "configuring tmux"
  ln -s "${cwd}"/tmux/_tmux "$HOME"/.tmux
  ln -s "${cwd}"/tmux/_tmux.conf "$HOME"/.tmux.conf

  return 0
}

##---------------------- Shell Configuration --------------------##

# Set the colors I want. Not always necessary to do this, it is very terminal specific.
# I am just in the habit of doing it so, why not.
install_dircolors() {
  if [ -f "$HOME"/.dir_colors ]; then
    echo "dir_colors already installed. Skipping."
  else
    ln -s "${cwd}"/shell/_dir_colors "$HOME"/.dir_colors
  fi

  return 0
}

# Install and provide a baseline configuration for oh-my-zsh that a user can then configure
# to my hearts content for the next four hours. I don't bother with installing zsh and setting
# it as the default terminal as that is the standard shell in MacOS.
configure_oh_my_zsh() {
  # TODO remove the config backup when we are done
  local ans=""

  # Check to see if it is already installed
  if [ -f "$HOME/.oh-my-zsh/" ]; then
    echo "oh-my-zsh is already installed. Skipping installation"
  else
    # Remove any existing configuration just in case and then do an install
    rm -rf "$HOME"/.oh-my-zsh/
    curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
    ln -s "${cwd}"/oh-my-zsh/ "$HOME"/.oh-my-zsh
  fi

  return 0
}

# Drop my specific dotfiles onto the box
configure_shell_env() {
  ln -s "${cwd}"/shell/_aliasrc "$HOME"/.aliasrc
  ln -s "${cwd}"/shell/_exportrc "$HOME"/.exportrc
  ln -s "${cwd}"/shell/_secretsrc "$HOME"/.secretsrc
  ln -s "${cwd}"/shell/_zshrc "$HOME"/.zshrc
  ln -s "${cwd}"/shell/_functionsrc "$HOME"/.functionsrc

  return 0
}

# Configure Starship for my development prompt
configure_starship() {
  ln -s "${cwd}"/starship/starship.toml "$HOME"/.config/starship.toml

  return 0
}

# TODO Do something with this at some point
configure_gpg() {
  #  ln -s "${cwd}"/gnupg/gpg-agent.conf $HOME/.gnupg/gpg-agent.conf

  return 0
}

# Configure my current terminal emulator
configure_alacritty() {

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
    rm -rf "$HOME"/.config/nvim/
    ln -s "${cwd}"/nvim/nvim "$HOME"/.config/
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
    ln -s "${cwd}"/hyper/_hyper.js "$HOME"/.hyper.js
    ln -s "${cwd}"/hyper/_hyper_plugins "${Home}"/.hyper_plugins
  fi

  return 0
}

##---------------------- Git Configuration --------------------##

# Configure my git environment. Do not enable this unless you really know what
# you are doing. No, I'm serious. I have a lot of tweaks and touches in here
# due to having multiple profiles and working on many different projects.
configure_git() {

  if [ ! -f $HOME/.gitconfig ]; then
    echo "Installing a global git configuration file to my home directory."
    ln -s "${cwd}"/git/_gitconfig "$HOME"/.gitconfig
  fi

  return 0
}

##--------------------------- Main -------------------------##
main() {

  # Sanity check the environment and box
  initalize

  # Configure MacOS specific bits
  configure_osx

  # Install as many of the packages I need as I can
  install_homebrew

  # Setup my terminals
  configure_hyper
  configure_alacritty
  install_tmux

  # Setup my shell environment
  configure_oh_my_zsh
  configure_shell_env
  install_dircolors

  # Setup development specific bits
  configure_starship
  configure_git

  # Configure my editors
  configure_nvim

  # Misc bits and pieces
  configure_gpg

  echo "All done. Go be a creepy human"
  exit 0

}

# TODO tests?
# TODO secure this

main
