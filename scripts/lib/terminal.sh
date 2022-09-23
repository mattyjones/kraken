#! /bin/env bash

source util.sh
source development.sh
# TODO Complete the terminal file

  # Setup my terminals
  # configure_alacritty

##--------------------------- TMUX -------------------------##

# I use tmux as my primary terminal interface and run
# it on terminal startup.
install_tmux() {

  local pkgs=("tmux")
  package_install "${pkgs[@]}"
  check_error $?

  echo "Configuring tmux..."
  ln -s "$cwd/tmux/_tmux" "$HOME/.tmux"
  ln -s "$cwd/tmux/_tmux.conf" "$HOME/.tmux.conf"

  return 0
}


##-------------------------- Terminal ----------------------##

# install_alacritty installs and drops the configuration file for alacritty. Alacritty is my current
# terminal emulator for all platforms. It's very fast, easy to configure, and has all the options I need.
# When it starts I launch tmux automagically to allow me the flexibility I need. See the config file for more details.
install_alacritty() {

  # all installation methods currently require rust to be installed
  install_rust

  git clone https://github.com/alacritty/alacritty.git /tmp/alacritty
  cd /tmp/alacritty || return 1
  cargo build --release
  cd target/release || return 1
  sudo  mv alacritty /usr/local/bin
  sudo rm -rf /tmp/alacritty

  # Need to link the config file, not copy it
  ln -s "$cwd/alacritty/_alacritty.yml" "$HOME/.alacritty.yml"

  return 0
}

# install_dircolors sets the colors I want. Not always necessary to do this, it's very terminal
# and OS specific. I am just in the habit of doing it.
install_dircolors() {
  if [ -f "$HOME/.dir_colors" ]; then
    echo "dir_colors already installed. Skipping."
  else
    cp "$cwd/shell/_dir_colors" "$HOME/.dir_colors"
  fi

  return 0
}

# main is the main entry point for the terminal module. Functions should only be called from here and can be
# created or commented out as needed. Calling specific functions from the debian install script
# could cause dependency issues or create unresolved errors.
terminal_main() {
  install_tmux
  install_alacritty
  install_dircolors

  return 0
}
