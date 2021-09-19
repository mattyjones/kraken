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

install_neovim() {
  local pkgs=("neovim")
  package_install "${pkgs[@]}"

  install_patched_powerline_fonts

  git clone https://github.com/vim-airline/vim-airline "$HOME/.config/nvim"
  cp "$cwd/nvim/init.vim" "$HOME/.config/nvim/"

  git clone https://joshdick/onedark.vim /tmp/onedark

  cp -r /tmp/onedark/colors "$HOME/.config/nvim/"
  cp -r /tmp/onedark/autoload/onedark.vim "$HOME/.config/nvim/autoload/"
  cp -r /tmp/onedark/autoload/airline/themes/onedark.vim "$HOME/.config/nvim/autoload/airline/themes/"

  # how do we manage updating vim-powerline
  # can we do a git pull and then only if anything changed we re-install everything?

  rm -rf /tmp/onedark

return 0  
}

install_patched_powerline_fonts() {

  local pkgs=("base-devel" "xorg-mkfontscale"  "powerline")
  package_install "${pkgs[@]}"

  git clone https://aur.archlinux.org/powerline-fonts-git.git /tmp/powerline
  cd /tmp/powerline || return 1
  makepkg 
  sudo pacman -U ./*.zst

  rm -rf /tmp/powerline

  return 0
}