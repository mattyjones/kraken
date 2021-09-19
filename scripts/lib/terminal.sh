#! /bin/env bash

##---------------------- Terminal Configurations --------------------##

# Alacritty is my current terminal emulator for all platforms. It is
# very fast, easy to configure, and has all the options I need. When it starts
# I launch tmux automagically to allow me the flexibility I need. See the
# config file for more details.
install_alacritty() {
  local pkgs=("alacritty")
  package_install "${pkgs[@]}"
  cp "$cwd/alacritty/_alacritty.yml" "$HOME/.alacritty.yml"

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

terminal_main() {
  install_alacritty
  install_dircolors

  return 0
}