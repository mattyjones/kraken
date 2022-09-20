#! /bin/env bash

source util.sh

# Some functions in this module may require additional terminals to be installed. I have only tested my shell environment
# using XFCE4-terminal, mate-terminal, and alacritty.

#TODO Complete the shell file

  # Setup my shell environment
  #  configure_oh_my_zsh

##---------------------- Shell Configuration --------------------##


# Install and provide a baseline configuration for oh-my-zsh that a user can then configure
# to my hearts content for the next four hours. I don't bother with installing zsh and setting
# it as the default terminal as that is the standard shell in MacOS.
configure_oh_my_zsh() {
    local pkgs=("zsh")
  # TODO remove the config backup when we are done

  # Check to see if it is already installed
  if [ -f "$HOME/.oh-my-zsh/" ]; then
    echo "oh-my-zsh is already installed. Skipping installation"
    echo "Updating oh-my-zsh..."
    omz update
  else
    # Remove any existing configuration just in case and then do an install
    rm -rf "$HOME/.oh-my-zsh/"
    curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
    rm "$HOME/.zshrc.pre*" # Remove any backup files that were created
    rm "$HOME/.zshrc"      # Remove the stock zshrc file so we can link the custom one
  fi

# su $script_user -c "bash -c $(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) "" --unattended"

  # FIXME the .zshrc file is borked when we do a re-install
  # Add any updated themes, plugins, etc that are needed
  echo "Installing zsh plugins..."

  return 0
}

# Drop my specific dotfiles onto the box
configure_shell_env() {
  local pkgs=("zsh-syntax-highlighting")


  ln -s "$cwd/shell/_alias" "$HOME/.alias"
  ln -s "$cwd/shell/_exports" "$HOME/.exports"
  ln -s "$cwd/shell/_zshrc" "$HOME/.zshrc"
  ln -s "$cwd/shell/_functions" "$HOME/.functions"
  ln -s "$cwd/shell/_grep" "$HOME/.grep"

  if [ -f "$HOME/.secrets" ]; then
    echo "Base secrets file is already installed. Skipping"
  else
    cp "$cwd/shell/_secrets" "$HOME/.secrets"
  fi

  return 0
}

enable_zsh() {
  # Set ZSH as the default shell
  # There is a lot of pam noise and sed going on in here. It is simply due to the fact we are running
  # the script as the root user yet we want to change the shell of the user that invoked it.

  # TODO notifications about this and that it worked
  # TODO is it already the shell

  sed -i.bak '/auth       required   pam_shells.so/a auth       sufficient   pam_wheel.so trust group=chsh' /etc/pam.d/chsh
  groupadd chsh
  usermod -a -G chsh "$script_user"
  su "$script_user" -c "chsh -s $(which zsh)"
  gpasswd -d "$script_user" chsh
  groupdel chsh
  sed -i.bak '/auth       sufficient   pam_wheel.so trust group=chsh/d' /etc/pam.d/chsh

  reboot=true
}

##---------------------- Shell Configuration --------------------##

enable_zsh() {
  # Set ZSH as the default shell
  # There is a lot of pam noise and sed going on in here. It is simply due to the fact we are running
  # the script as the root user yet we want to change the shell of the user that invoked it.

  # TODO notifications about this and that it worked
  # TODO is it already the shell

  sed -i.bak '/auth       required   pam_shells.so/a auth       sufficient   pam_wheel.so trust group=chsh' /etc/pam.d/chsh
  groupadd chsh
  usermod -a -G chsh "$script_user"
  su "$script_user" -c "chsh -s $(which zsh)"
  gpasswd -d "$script_user" chsh
  groupdel chsh
  sed -i.bak '/auth       sufficient   pam_wheel.so trust group=chsh/d' /etc/pam.d/chsh

  reboot=true
}

install_oh_my_zsh() {
# Install oh-my-zsh and configure it
# if the want to change the shell and switch to it now
$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) "" --unattended
}

enable_zsh() {
# Enable zsh as the default shell
sed -i.bak '/auth       required   pam_shells.so/a auth       sufficient   pam_wheel.so trust group=chsh' /etc/pam.d/chsh
groupadd chsh
usermod -a -G chsh $script_user
su $script_user -c "chsh -s $(which zsh)"
gpasswd -d $script_user chsh
groupdel chsh
sed -i.bak '/auth       sufficient   pam_wheel.so trust group=chsh/d' /etc/pam.d/chsh
}

# main is the main entry point for the gui module. Functions should only be called from here and can be
# created or commented out as needed. Calling specific functions from the debian install script
# could cause dependency issues or create unresolved errors.
shell_main() {

}
