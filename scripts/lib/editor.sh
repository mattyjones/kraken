#! /bin/env bash

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
  local pkgs=("neovim" "vscode")
}
