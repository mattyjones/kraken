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

# TODO Need to check all the links to see if they exist and are pointing to the right place
# TODO Some kind of a user menu
# TODO Respect 80 character limit when possible
# TODO can we add the jetbrains toolbox, alfred, keeper, to the brew file
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

  # Make sure the necessary directorys exist and if not create them.
  if [[ -d "$HOME/.config" ]]; then
    echo "Creating the user .config directory"
    mkdir "$HOME/.config"
  fi

  return 0
}

# Bring in XCode tools if needed
install_dev_tools() {
  echo "Installing Apple XCode cli tools..."
  if [ -n "$(sudo xcode-select -v)" ]; then
    if ! [ "$(sudo xcode-select --install)" ]; then
      echo "Developer tools install failed"
    fi
  else
    echo "XCode developer tools already installed"
  fi

  return 0

}

##---------------------- MacOS Specific Configuration --------------------##

# TODO Need to capture the return status. Do not run this without some additional
# checks so things don't get borked.

# Install any software updates necessary. Does not work
# for OS updates for some reason.
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
    echo "Installing Homebrew..."
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
    ln -s "$cwd/homebrew/Brewfile" "$brew_file"
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
  if brew cleanup > "$HOME/Desktop/brew_cleanup"; then
    echo "Homebrew cleanup list was created successfully"
  else
    echo "'brew cleanup' failed"
    exit 1
  fi

  echo "Homebrew Installation Complete"

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

##---------------------- Install CPAN --------------------##

# Install and configure cpan. I need Perl some some specific projects. 
install_cpan() {

  echo "configuring cpan"
  sudo cpan App::cpanminus

  return 0

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

##---------------------- GPG Configuration --------------------##

# TODO Do something with this at some point
configure_gpg() {
  #  ln -s "$cwd/gnupg/gpg-agent.conf $HOME/.gnupg/gpg-agent.conf

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

# This is my personal config file for testing and using wraith
# https://github.com/N0MoreSecr3ts/wraith
configure_wraith() {
  mkdir "$HOME/.wraith"
  ln -s "$cwd/wraith/config.yaml" "$HOME/.wraith/config.yaml"

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
