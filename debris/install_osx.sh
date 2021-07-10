#!/usr/bin/env bash

# Get current dir (so run this script from anywhere)

export DOTFILES_DIR EXTRA_DIR
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
EXTRA_DIR="$HOME/.extra"

# Update dotfiles itself first

[ -d "$DOTFILES_DIR/.git" ] && git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin master

# Bunch of symlinks

ln -sfv "$DOTFILES_DIR/runcom/.bash_profile" ~
ln -sfv "$DOTFILES_DIR/runcom/.inputrc" ~
ln -sfv "$DOTFILES_DIR/runcom/.tmux.conf" ~
ln -sfv "$DOTFILES_DIR/git/.gitconfig" ~
ln -sfv "$DOTFILES_DIR/git/.gitignore_global" ~
ln -sfv "$DOTFILES_DIR/git/.gitsettings" ~

# Package managers & packages

. "$DOTFILES_DIR/install/brew.sh"
. "$DOTFILES_DIR/install/bash.sh"
. "$DOTFILES_DIR/install/node.sh"
. "$DOTFILES_DIR/install/vundle.sh"

if [ "$(uname)" == "Darwin" ]; then
    . "$DOTFILES_DIR/install/brew-cask.sh"
fi

# Run tests

bats test/*.bats

# Install extra stuff

if [ -d "$EXTRA_DIR" -a -f "$EXTRA_DIR/install.sh" ]; then
    . "$EXTRA_DIR/install.sh"
fi


#!/usr/bin/env bash
debug=${1:-false}

# Load help lib if not already loaded.
if [ -z ${libloaded+x} ]; then
  source ./lib.sh
fi;

action "Setting up .nanorc"
# Install better nanorc config.
# https://github.com/scopatz/nanorc
curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh

action "Setting chmod for ~/.ssh"
chmod 700 "$HOME/.ssh"
print_result $? "Set chmod 700 on ~/.ssh"

action "Setting chmod for ~/.gnupg"
mkdir "$HOME/.gnupg"
chmod 700 "$HOME/.gnupg"

# Install the Solarized Dark theme for Terminal
action "Installing Solarized Dark for Terminal"
open "${dotfilesdir}/terminal/Solarized Dark xterm-256color.terminal"

# Install the Solarized Dark High Contrast theme for iTerm2
action "Installing Solarized Dark High Contrast for iTerm2"
open "${dotfilesdir}/iterm2/Solarized Dark High Contrast.itermcolors"

success "Final touches in place."
