#! /bin/bash

#TODO need to check all the links to see if they exist and are pointing to the right place
# TODO Some kind of a user menu saying the existing stuff will be removed

##-- initalize script --##
initalize() {
  cwd=$(pwd)
  user_name=$(logname)

  if [ -n "$(curl -v)" ]; then
    echo "curl is not installed."
    echo "curl should of been installed by default"
    exit 1
  fi

}

##-- install homebrew --##
install_homebrew() {

  echo "Installing homebrew"
  if [ -n "$(brew -v)" ]; then
    echo "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    echo "Homebrew is already installed"
  fi

  if [ ! -f "/~Brewfile" ]; then
    echo "Linking brewfile"
    ln -s "${cwd}"/homebrew/Brewfile /Users/"{$user_name}"/Brewfile
  fi

  echo "installing homebrew packages"
  brew update
  brew bundle install --cleanup --file ~/Brewfile
}

##-- Install TMUX --##
install_tmux() {

  echo "configuring tmux"
  ln -s "${cwd}"/tmux/_tmux /Users/"${user_name}"/.tmux
  #  ln -s _tmux ~/.tmux
  #  mv ~/_tmux ~/.tmux
  ln -s "${cwd}"/tmux/_tmux.conf /Users/"${user_name}"/.tmux.conf
  #    ln -s "$(pwd)"/_tmux/_tmx.conf ~/.tmux.conf
  #  mv ~/.tmux/_tmux.conf ~/.tmux.conf
}

install_dircolors() {
  ln -s "${cwd}"/shell/_dir_colors /Users/"${user_name}"/.dir_colors
}

# Install and provide a baseline configuration for oh-my-zsh that a user can then configure
# to their hearts content for the next four hours.
configure_oh_my_zsh() {
  # TODO remove the config backup when we are done
  local ans=""

  # Check to see if it is already installed
  if [ -f "${HOME}/.oh-my-zsh/" ]; then
    echo "oh-my-zsh is already installed. Do you wish to reinstall it? This will replace your current configuration [Y/n]"
    read -r ans
    if [[ "${ans}" == "n" ]]; then
      echo "Skipping installation"
    else
      echo "Removing existing configuration and reinstalling oh-my-zsh"
      rm -rf "${HOME}"/.oh-my-zsh/
      curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
      ln -s "${cwd}"/oh-my-zsh/ /Users/"${user_name}"/.oh-my-zsh
    fi
  fi
}

configure_shell_env() {
  ln -s "${cwd}"/shell/_aliasrc /Users/"${user_name}"/.aliasrc
  ln -s "${cwd}"/shell/_exportrc /Users/"${user_name}"/.exportrc
  ln -s "${cwd}"/shell/_secretsrc /Users/"${user_name}"/.secretsrc
  ln -s "${cwd}"/shell/_zshrc /Users/"${user_name}"/.zshrc
  ln -s "${cwd}"/shell/_functionsrc /Users/"${user_name}"/.functionsrc
}

configure_starship() {
  ln -s "${cwd}"/starship/starship.toml /Users/"${user_name}"/.config/starship.toml
}

configure_gpg() {
  ln -s "${cwd}"/gnupg/gpg-agent.conf /Users/"${user_name}"/.gnupg/gpg-agent.conf
}

configure_nvim() {
  # TODO make sure the config dir is there
  # TODO check to make sure neovim is installed

    # Check to see if it is already installed
  if [ -f "${HOME}/.config/nvim/" ]; then
    echo "nvim may already be configured. Do you wish to use the new configuration or keep the current one?"
     echo "Replace the existing configuration[Y/n]"

    read -r ans
    if [[ "${ans}" == "n" ]]; then
      echo "Skipping kracken neovim installation"
    else
      echo "Removing existing configuration and installing kracken"
      rm -rf "${HOME}"/.config/nvim/
ln -s "${cwd}"/nvim/nvim /Users/"${user_name}"/config/
    fi
  fi


}

configure_hyper() {
  # Removing the default setup
  rm -rf ~/.hyper*

  echo "configuring the custom hyper.js"
  ln -s "${cwd}"/hyper/_hyper.js /Users/"${user_name}"/.hyper.js
  ln -s "${cwd}"/hyper/_hyper_plugins /Users/"${user_name}"/.hyper_plugins

}

main() {
  initalize
  install_homebrew
  configure_oh_my_zsh
  configure_shell_env
  install_dircolors
  install_tmux
  configure_hyper
}

# TODO tests?
# TODO secure this
# TODO do we need user intervention

main
