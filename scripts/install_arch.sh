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
#    scripts/install_arch.sh
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

<<<<<<< HEAD

=======
>>>>>>> bb12368 (Initial breakup of files)
##----------------------- Initialization ---------------------##

# Set the path to include the libraries. These are searched for in the same directory or within the path. We capture
# the original path statement and then prepend the library directory. Once we have sourced all the functions we drop
# back to the original path to minimize possible mangling.
library_import() {

  local ORIG_PATH="$PATH"
  export PATH="lib:$PATH"

  source blackarch
  source development
  source editor
  source gui
  source networking
  source shell
  source terminal
  source util
  source vmware

  export PATH="$ORIG_PATH"

  return 0
}

# Initialize gathers basic info, performs any setup configurations and makes
# sure any script dependencies are met. It will not check to see what it is
# running as or if the user is setup correctly. Don't be lazy, don't run
# this as root.
initialize() {
  echo "Starting installation..."

  # Bring in all necessary libraries and external functions
  library_import

  # Get the current working directory for reference. Do use pwd
  # in the script as the current directory could be different
  # from the base directory and screw up any relative paths
  cwd=$(pwd)

  # Ask for the administrator password upfront. Do run the script as root.
  # This should always be run as the user whose account will be used. Sudo
  # may be needed for specific actions so that is called up front so automation
  # does not break.
  sudo -v

  # Keep-alive: update existing `sudo` time stamp until we have finished. This
  # ensures that sudo does not expire before the script completes.
  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done 2>/dev/null &

  # Upgrade the entire system to ensure we have a stable platform
  system_upgrade

  # Install curl if it is not already present
  if [ -n "$(curl -v)" ]; then
    echo "Installing curl"
    package_install curl
  fi

  # Install wget if it is not already present
  if [ -n "$(wget -v)" ]; then
    echo "Installing wget"
    package_install wget
  fi

  return 0
}

<<<<<<< HEAD

=======
>>>>>>> bb12368 (Initial breakup of files)
##--------------------------- Main -------------------------##
main() {

  # Initialize the script and ensure we have a correct baseline image
  if ! initialize; then
    echo "Initialization failed"
    exit 1
  fi

  # When installing only specific pieces you may need to modify the
  # script to ensure tools are available as needed. This may not be
  # called out and the tool will break if certain build tools and headers
  # are not present as dependencies.

  # Install as many of the packages I need as I can
  # install_homebrew

  # Setup my terminals
  #configure_alacritty
  # configure_tmux

  # Setup my shell environment
  #  configure_oh_my_zsh
  #  configure_shell_env
  #  install_dircolors

  # Setup development specific bits
  #  configure_starship
  #  configure_git
  # install_cpan
  #  install_ruby
  #  install_editorconfig
  #  configure_wraith

  # Configure my editors
  #  configure_nvim

  # Misc bits and pieces
  # configure_gpg

  echo "All done. Go be a creepy human"
  exit 0

}

main 
# TODO tests?

#main
#
#
#
#cleanup() {
#
#  if [[ $reboot == true ]]; then
#    echo "Do you want to reboot now? [Y/n]"
#    reqd -r ans
#
#    if [[ $ans == "Y" ]]; then
#      init 6
#    fi
#  else
#    echo "It is always a good idea to reboot after configuring a new shell"
#  fi
#}
#
#
#
#
## Various tools I find useful and helpful (these are optional)
#tools_pkgs=("jq" "bat" "rsync" "gvfs")
#
#network_pkgs=("network-manager" "openconnect")
#
## The VM share dir
#share_dir="sharefs"
#
## Set this to true if we need to do a reboot, specifically for the shell change
#reboot=false
