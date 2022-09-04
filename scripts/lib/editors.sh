#! /bin/env bash

  # Configure my editors
  #  configure_nvim
  # TODO can we do some dynamic install/config of neovim instead
  #  of carrying around the entire folder
##---------------------- Neovim Configuration --------------------##

install_vscode() {
  local pkgs=("vscode")
  package_install "${pkgs[@]}"
}

install_neovim() {
  local pkgs=("neovim")
  package_install "${pkgs[@]}"

  install_patched_powerline_fonts

  if ! [[ -d "$HOME/.config/nvim" ]]; then

    git clone https://github.com/vim-airline/vim-airline "$HOME/.config/nvim"
    cp "$cwd/nvim/init.vim" "$HOME/.config/nvim/"
  fi

  # git clone https://github.com/vim-airline/vim-airline "$HOME/.config/nvim"
  # cp "$cwd/nvim/init.vim" "$HOME/.config/nvim/"

  git clone https://github.com/joshdick/onedark.vim /tmp/onedark

  cp -r /tmp/onedark/colors "$HOME/.config/nvim/"
  cp -r /tmp/onedark/autoload/onedark.vim "$HOME/.config/nvim/autoload/"
  cp -r /tmp/onedark/autoload/airline/themes/onedark.vim "$HOME/.config/nvim/autoload/airline/themes/"

  # how do we manage updating vim-powerline
  # can we do a git pull and then only if anything changed we re-install everything?

  # rm -rf /tmp/onedark

  return 0
}

install_sublime() {
  curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
  echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf

  local pkgs=("sublime-text")
  package_install "${pkgs[@]}"
}

install_patched_powerline_fonts() {

  local pkgs=("base-devel" "xorg-mkfontscale" "powerline")
  package_install "${pkgs[@]}"

  git clone https://aur.archlinux.org/powerline-fonts-git.git /tmp/powerline
  cd /tmp/powerline || return 1
  makepkg
  sudo pacman -U --noconfirm ./*.zst

  # rm -rf /tmp/powerline

  return 0
}

editors_main() {
  install_vscode
  install_neovim

  return 0
}

https://aur.archlinux.org/packages/sublime-text-4/
