#! /bin/env bash

source util.sh
# TODO Complete the editors file

  # Configure my editors
  #  configure_nvim
  # TODO can we do some dynamic install/config of neovim instead
  #  of carrying around the entire folder
##---------------------- Neovim Configuration --------------------##

install_vscode() {
  wget https://code.visualstudio.com/sha/download\?build\=stable\&os\=linux-deb-arm64 -O linux-armhf.deb
  sudo dpkg -i linux-armhf.deb

}

install_vim_airline() {

  git clone https://github.com/vim-airline/vim-airline.git /tmp/airline
  cp -r /tmp/airline/autoload /tmp/airline/plugin $HOME/.config/nvim/
  rm -rf /tmp/airline

}

install_vim_nord() {
    git clone https://github.com/arcticicestudio/nord-vim.git /tmp/nord-vim
  cp /tmp/nord-vim/autoload/airline/themes/nord.vim ~/.config/nvim/autoload/airline/themes/
  cp -r /tmp/nord-vim/colors ~/.config/nvim
  rm -rf /tmp/nord-vim
}

install_vim_onedark() {
    git clone https://github.com/joshdick/onedark.vim /tmp/onedark

  cp -r /tmp/onedark/colors/onedark.vim "$HOME/.config/nvim/colors/"
  cp -r /tmp/onedark/autoload/onedark.vim "$HOME/.config/nvim/autoload/"
  cp -r /tmp/onedark/autoload/airline/themes/onedark.vim "$HOME/.config/nvim/autoload/airline/themes/"
}

install_neovim() {

  # Install neovim
  local pkgs=("neovim")
  package_install "${pkgs[@]}"

  # Copy in the base config file
  ln -s "$cwd/nvim/init.vim" "$HOME/.config/nvim/"

  # TODO: make all the directories by hand so the order of the packages does not matter

  # To keep things simple the functions should be executed in this order. If they are not tweaking will be needed.
  install_patched_powerline_fonts
  install_vim_airline
  install_vim_nord
  install_vim_onedark



  # how do we manage updating vim-powerline
  # can we do a git pull and then only if anything changed we re-install everything?

  # rm -rf /tmp/onedark

  return 0
}

install_sublime() {
  curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
  echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf
  sudo apt update

  local pkgs=("sublime-text")
  package_install "${pkgs[@]}"
}

install_patched_powerline_fonts() {

  local pkgs=("fonts-powerline")
  package_install "${pkgs[@]}"

#  git clone https://aur.archlinux.org/powerline-fonts-git.git /tmp/powerline
#  cd /tmp/powerline || return 1
#  makepkg
#  sudo pacman -U --noconfirm ./*.zst
#
#  # rm -rf /tmp/powerline

  return 0
}

editors_main() {
  install_vscode
  install_neovim
  install_sublime

  return 0
}
