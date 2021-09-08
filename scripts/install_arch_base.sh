#! /bin/env bash
#
#  Kraken
#
# AUTHOR: Matt Jones
#
# DESCRIPTION:
#    Kraken is a semi-automated and opinionated environment configuration tool.
#    Application and tool specific configurations are easy to modify. All tools
#    are built and installed as isolated as possible to ensure modularity and
#    user specific tastes.
#
# OUTPUT:
#    plain-text
#
# PLATFORMS:
#    Arch Linux
#
# DEPENDENCIES:
#    bash
#
# USAGE:
#    scripts/install_arch_base.sh
#
# NOTES:
#
# LICENSE:
#    MIT
#

##--------------------------- Prework ----------------------------------##

# You will need to download and unpack a vagrant image. This is the smallest pre-built
# imange availabe that I am aware of. Once this is complete log in and setup a few things.

# 1. https://gitlab.archlinux.org/archlinux/arch-boxes/-/jobs/32554/artifacts/browse/output
# 2. `tar -xf <image>
# 3. Import the box into vmware fusion
# 4. Boot the box and login w/ vagrant:vagrant
# 5. `sudo su -`
# 6. `adduser -d /home/$USER -G wheel -m $USER`
# 8. `passwd $USER $PASSWORD`
# 9. `cp -R /home/vagrant/ .* /home/$USER/`
# 10. `chown -R $USER:$USER /home/$USER`
# 11. pacman -S --noconfirm vi curl wget
# 12. Enable the wheel group in sudoers
# 13. `groupadd -a -G wheel`
# 14. log out and login in as $USER


##----------------------- Initialize config script ---------------------##

# Initialize gathers basic info, performs any setup configurations and makes
# sure any script dependencies are met. It will not check to see what it is
# running as or if the user is setup correctly. Don't be lazy, don't run
# this as root.
initialize() {
  echo "Starting installation..."
  cwd=$(pwd)

  # Ask for the administrator password upfront
  sudo -v

  # Keep-alive: update existing `sudo` time stamp until we have finished
  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done 2>/dev/null &

  system_upgrade

  if [ -n "$(curl -v)" ]; then
    echo "Installing curl"
    package_install curl
  fi

  if [ -n "$(wget -v)" ]; then
    echo "Installing wget"
    package_install wget
  fi

  return 0
}

##--------------------------- Main -------------------------##
main() {

  # Sanity check the environment and box
  initalize

  # This is very expermental, enable at your own peril. I suggest
  # creating a backup first
  # Configure MacOS specific bits
  # configure_osx

  # Install as many of the packages I need as I can
  install_homebrew

  # Setup my terminals
  configure_alacritty
  configure_tmux

  # Setup my shell environment
  configure_oh_my_zsh
  configure_shell_env
  install_dircolors

  # Setup development specific bits
  configure_starship
  configure_git
  # install_cpan
  install_ruby
  install_editorconfig
  configure_wraith

  # Configure my editors
  configure_nvim

  # Misc bits and pieces
  # configure_gpg

  echo "All done. Go be a creepy human"
  exit 0

}

# TODO tests?

main



cleanup() {

  if [[ $reboot == true ]]; then
    echo "Do you want to reboot now? [Y/n]"
    reqd -r ans

    if [[ $ans == "Y" ]]; then
      init 6
    fi
  else
    echo "It is always a good idea to reboot after configuring a new shell"
  fi
}


# TODO fix masscan build error
# TODO Fix masscan directory error
# TODO capture return values
# TODO catch warnings
# TODO colored output
# TODO make secure
# TODO quit output
# TODO capture error output and STDERR
# TODO install airline for vim and terminal
# TODO install nord
# TODO install nord tmux theme
# TODO install zsh-dircolors-nord
# TODO install lightline for nvim
# TODO install nord for nvim
# TODO configure nvim

# Various tools I find useful and helpful (these are optional)
tools_pkgs=("jq" "bat" "rsync" "gvfs")

network_pkgs=("network-manager" "openconnect")

# The VM share dir
share_dir="sharefs"

# Set this to true if we need to do a reboot, specifically for the shell change
reboot=false
