#! /bin/env bash

source util.sh
#
# This installs an opinionated development environment and the common languages
# I use. If you don't want specific languages you can remove the functions from
# the main() function at the bottom of the file.
# Some of these langagues may be installed as dependencies for other programs
#
# TODO Complete the development file
# TODO Add colors

  #  [ ] install_git # TODO different package
  #  [ ] install_ruby # TODO different package
  #  [ ] install_python # TODO different package
  #  [ ] Install_rust # TODO different package

source util.sh
source ../install_debian.sh

##------------------------------ Editorconfig ---------------------------##

# Install the root  editorconfig file
# https://editorconfig.org
# TODO Add debugging to include the version installed and the version to be installed
# TODO Check for errors
# TODO Test install_cpan function
install_editorconfig() {
  ln -s "$cwd/editorconfig/_editorconfig" "$HOME/.editorconfig"

  return 0
}

##------------------------------ Starship ---------------------------##

# Configure Starship for my development prompt
# https://starship.rs
# TODO Add debugging to include the version installed and the version to be installed
# TODO Check for errors
# TODO Test install_starship function
install_starship() {

  # Rust is need to build Starship
  install_rust

  curl -sS https://starship.rs/install.sh | sh
  # TODO Check for errors
  # TODO Add debug functionality

  # Bring in my opinionated config file
  configure_starship

  return 0
}

# Configure Starship for my development prompt
configure_starship() {
  ln -s "$cwd/starship/starship.toml" "$HOME/.config/starship.toml"

  return 0
}

##---------------------- Golang --------------------##

# Install Golang and set the GOPATH. This is my way of doing things and a little against
# the traditional way, but it makes for a cleaner multi-language dev environment.

# TODO Add debugging to include the version installed and the version to be installed
# TODO Check for errors
# TODO Test install_golang function
install_golang() {
  echo "Installing Golang"

  if [[ "$(go version)" ]]; then
    echo "Golang is already installed"
  else
    check_tools "golang"
  fi

  if [ ! -d "$HOME/Projects/Go" ]; then
    echo "Creating GOPATH"
    mkdir -p "$HOME/Projects/Go/{src,pkg,bin}"
  fi

  return 0
}

install_base_dev() {
  local pkgs=("git" "starship" "base_devel" "shfmt")
}

install_base_dev() {
  local pkgs=("shfmt")
}

install_python_devel() {
  local pkgs=("python_pipenv")
}

##---------------------- Install Perl --------------------##

# TODO Add debugging to include the version installed and the version to be installed
# TODO Check for errors
# TODO Test install_perl function
install_perl() {
  echo "" # TODO how do we install Perl
}

# Install and configure cpan. I need Perl some specific projects.
# TODO Add debugging to include the version installed and the version to be installed
# TODO Check for errors
# TODO Test install_cpan function
install_cpan() {

  if [[ "$(which cpan)" ]]; then
    echo "Cpan is already installed"
  else
    echo "" # TODO how do we install cpan
  fi

  echo "Configuring cpan"
  sudo cpan App::cpanminus

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

  make sure it is in the path
  ~/.rubies/ruby-*/bin/bundle install

  # pry does not work

  wget -O ruby-install-0.8.2.tar.gz https://github.com/postmodern/ruby-install/archive/v0.8.2.tar.gz
  tar -xzvf ruby-install-0.8.2.tar.gz
  cd ruby-install-0.8.2/
  sudo make install

  ruby-install ruby #(latest stable)

  wget -O chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz
  tar -xzvf chruby-0.3.9.tar.gz
  cd chruby-0.3.9/
  sudo scripts/setup.sh

  return 0
}

##---------------------- Python Installation --------------------##

# Install Python3 and create the project directory if it does not already exist. Along with
# python3 you should also install pipenv and some other basic packages.
install_python() {
  echo "Installing Python3"

  if [[ "$(python3 --version)" ]]; then
    echo "Python3 is already installed"
  else
    echo "Add python3 to your brewfile and run `brew bundle install`"
  fi

  if [[ "$(pipenv -h)" ]]; then
    echo "Pipenv is already installed"
  else
    echo "Add pipenv to your brewfile and run `brew bundle install`"
  fi

  if [ ! -d "$HOME/Projects" ]; then
    echo "Creating project directory"
    mkdir -p "$HOME/Projects"
  fi

  return 0
}


# Install a general development environment. Currently, this is a placeholder as
# the specific tools I want are installed on their own.
install_development_env() {

  echo "Creating base project directory"

  if [ ! -d "$HOME/Projects" ]; then
    echo "Creating project directory"
    mkdir -p "$HOME/Projects"
  fi

  install_golang          # Go language
  install_starship        # Starship prompt
  install_perl            # Perl + CPAN
  install_editorconfig    # Editorconfig

  return 0

}

install_general_pkgs(){

  local pkgs=( "jq" "lnav")
  package_install "${pkgs[@]}"
  check_error $?
}

