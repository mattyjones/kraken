#! /bin/bash
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
#    OSX, MacOs
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

# TODO need to check all the links to see if they exist and are pointing to the right place
# TODO Some kind of a user menu saying the existing stuff will be removed

##---------------------- Initialize script --------------------##

# This gathers basic info, performs any setup configurations and makes sure any script dependencies
# are met.
initalize() {
  cwd=$(pwd)
  user_name=$(logname)

  if [ -n "$(curl -v)" ]; then
    echo "curl is not installed."
    echo "curl should of been installed by default"
    exit 1
  fi

  # Bring in XCode tools
  softwareupdate -i -a
  xcode-select --install

}

# add_if_missing() {
# {
#   awk '{
#     while (NR + shift < $1) {
#         print (NR + shift) " NA"
#         shift++
#     }
#     print
# }
# END {
#     shift++
#     while (NR + shift < 13) {
#         print (NR + shift) " NA"
#         shift++
#     }
# } 
# }'
# }

#update_brewfile() {
#  existing_brewfile=""
#  kracken_brewfile="$cwd/homebrew/Brewfile"
#  if [ ! "$HOME/Brewfile" ]; then
#    existing_brewfile="/Users/$user_name/Brewfile"
#    echo "Installing Kracken Brewfile"
#    if [! $(grep -Fxq "string" $existing_brewfile)]; then
#      echo "\n --- Kracken Packages ---\n" > existing_brewfile
#    fi
#    cp "${cwd}"/homebrew/Brewfile /Users/"{$user_name}"/Brewfile
#  fi
#if ! grep -q "\--- Kracken Packages ---" existing_brew; then echo "not found" >> existing_brew; else; echo "I got you" >> existing_brew; fi
#
#  echo "\n --- Kracken Packages ---\n" >> existing_brew && diff existing_brew my_brew | grep '^>' | sed 's/^>\ //' >>  existing_brew
#}

##---------------------- Install Homebrew --------------------##

# We check to see if homebrew is installed and if not then we install it. After it completes
# we install the brewfile and install all programs contained in it.
install_homebrew() {

  echo "Do you want to install Homebrew [Y/n]"
  read ans
  if [[ $ans == "" ]] || [[ $ans == "Y" ]]; then
    echo "Installing homebrew"
  if [ -n "$(brew -v)" ]; then
    echo "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    echo "Homebrew is already installed"
  fi
  fi

  install_brewfile
}

install_brewfile() {
#    echo "Do you want to use the default Brewfile. This will add any additional Kracken packages to an existing Brewfile. [Y/n]"
#    read ans
#    if [[ $ans == "" ]] || [[ $ans == "Y" ]]; then
#     echo "Adding Kracken packages to the Brewfile"

    # echo "Installing homebrew"
  # if [ -n "$(brew -v)" ]; then
  #   echo "Installing Homebrew"
  #   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # else
  #   echo "Homebrew is already installed"
  # fi


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

#configure_gpg() {
#  ln -s "${cwd}"/gnupg/gpg-agent.conf /Users/"${user_name}"/.gnupg/gpg-agent.conf
#}

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

configure_git() {

  echo "Do you want to install the kracken .gitconfig to \$HOME/.gitconfig?"
  read -r ans
  if [[ $ans == "" ]] || [[ $ans == "Y" ]]; then
    if [ ! -f $HOME/.gitconfig ]; then
      echo "A global .gitconfig down not exist using kracken"
      ln -s "${cwd}"/git/_gitconfig /Users/"${user_name}"/.gitconfig
    fi

    echo "What name will you commit with? This is usually your real name."
    read -r name
    git config --global user.name $name

    echo "What email will you commit with?"
    read -r email
    git config --global user.email $email
  fi

}

main() {
  initalize
  git
  gpg
  install_homebrew
  configure_hyper
  configure_nvim
  configure_oh_my_zsh
  configure_shell_env
  configure_starship
  install_dircolors
  install_tmux
  configure_osx

}

# TODO tests?
# TODO secure this

main
