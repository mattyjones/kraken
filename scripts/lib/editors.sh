#! /bin/env bash

source util.sh
# TODO Complete the editors file

  # Configure my editors

##---------------------- Neovim Configuration --------------------##

# install_vscode installs an Apple M1 specific version of vscode
install_vscode() {
  wget https://code.visualstudio.com/sha/download\?build\=stable\&os\=linux-deb-armhf -O linux-armhf.deb
  sudo dpkg -i linux-armhf.deb

  return 0
}

# install_vim_airline installs the airline status bar
# https://github.com/vim-airline/vim-airline
install_vim_airline() {

  git clone https://github.com/vim-airline/vim-airline.git /tmp/airline
  cp -r /tmp/airline/autoload/* "$HOME/.config/nvim/autoload/"
  cp -r /tmp/airline/plugin/* "$HOME/.config/nvim/plugin/"
  rm -rf /tmp/airline

  return 0
}

# install_vim_nord installs the nord vim theme
# https://github.com/arcticicestudio/nord-vim
install_vim_nord() {

  git clone https://github.com/arcticicestudio/nord-vim.git /tmp/nord-vim
  cp /tmp/nord-vim/autoload/airline/themes/nord.vim "$HOME/.config/nvim/autoload/airline/themes/"
  cp -r /tmp/nord-vim/colors/nord.vim "$HOME/.config/nvim/colors/"
  rm -rf /tmp/nord-vim

  return 0
}

# install_vim_onedark installs the nord vim theme
install_vim_onedark() {
  git clone https://github.com/joshdick/onedark.vim /tmp/onedark

  cp -r /tmp/onedark/colors/onedark.vim "$HOME/.config/nvim/colors/"
  cp -r /tmp/onedark/autoload/onedark.vim "$HOME/.config/nvim/autoload/"
  cp -r /tmp/onedark/autoload/airline/themes/onedark.vim "$HOME/.config/nvim/autoload/airline/themes/"

  return 0
}

# install_patched_powerline_fonts installs the specific powerline fonts needed for the airline status bar
install_patched_powerline_fonts() {

  local pkgs=("fonts-powerline")
  package_install "${pkgs[@]}"

  return 0
}

# install_neovim installs neovim. Neovim is a drop-in replacement for vim but has a simplier api for writing plugins.
install_neovim() {

  # Install neovim
  local pkgs=("neovim")
  package_install "${pkgs[@]}"

  # Create initial directories
  mkdir "$HOME/.config/nvim/autoload"
  mkdir "$HOME/.config/nvim/colors"
  mkdir "$HOME/.config/nvim/plugin"

  # Copy in the base config file
  ln -s "$cwd/nvim/init.vim" "$HOME/.config/nvim/"

  # To keep things simple the functions should be executed in this order. If they are not tweaking will be needed.
  install_patched_powerline_fonts
  install_vim_airline
  install_vim_nord
  install_vim_onedark

  return 0
}

# install_sublime installs sublime-test
install_sublime() {
  wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg\
  echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list\
  sudo apt update

  local pkgs=("sublime-text")
  package_install "${pkgs[@]}"
}

# editors_main will install my prefered editors and drop their specific configuration files
editors_main() {
  install_vscode
  install_neovim
  install_sublime

  return 0
}
