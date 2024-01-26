#!/usr/bin/perl
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
#    x86_64, ARM
#
# OPERATING SYSTEMS:
#    OSX, MacOS, Arch, ParrotOS, Kali
#
# DEPENDENCIES:
#    perl 5
#
# USAGE:
#    scripts/configure_osx
#
# NOTES:
#
# LICENSE:
#    MIT
#

# TODO Need to check all the links to see if they exist and are pointing to the right place
# TODO Some kind of a user menu
# TODO Respect 80 character limit when possible
# TODO can we add alfred to the brew file
# TODO list of vscode extensions
# TODO some sort of jetbrains configs, beyond the cloud
# use native perl where possible
# implement debuging
# tests


use warnings;
use strict;

use Term::ANSIColor qw(:constants);
use Getopt::Long qw(GetOptions);
use Cwd qw(getcwd);
use File::Spec::Functions;

local $Term::ANSIColor::AUTORESET = 1;

my $DEBUG    = 0;
my $SILENT   = 0;
my $COMMAND  = "";
my $BASE_DIR = getcwd();
my $VERSION  = "0.0.1";

my $owner = `logname`;
my $home_dir = $ENV{"HOME"};
chomp($owner);

##---------------------- Initialize config script --------------------##

sub create_config_directories {
    my $config_dir = $ENV{"HOME"} . "/.config";

    # Create any configuration directories needed
    print GREEN, "[*] Checking for ", $config_dir, "configuration directories\n", RESET;
    
    if ( -e $config_dir ) {}
    else {
        print "[*] Creating the user \$HOME\\.config directory\n";
        mkdir $home_dir;
    }

    if ( -e $config_dir ){}
    else {
        print RED, "There was an error creating the home directory", RESET;
        exit 101
    }
    print GREEN, "[*]\n", RESET;

    return 0;
}


sub enable_sudo {
    # Ask for the administrator password upfront
    print GREEN, "[*] Setting up sudo\n", RESET;
    `sudo -v`;

    if ($DEBUG) {
        print YELLOW, "Effective UID: ", $>, RESET;
    }

    print "[*] Privilage escalation enabled\n";
    print GREEN, "[*]\n";

    # Keep-alive: update existing `sudo` time stamp until we have finished
    while( 0 ) {
        `sudo -n true`;
        sleep(60);
        `kill -0 "$$" || exit`;
        `done 2>/dev/null &`;
    }

    return 1;
}

sub check_binaries {
    print GREEN, "[*] Checking for required tools\n", RESET;

    # Check to make sure curl is present and in the path
    my $curl_binary    = system("curl -V &> /dev/null");
    
    if ( $curl_binary != 0 ) {
        print RED, "This tools requires curl\n";
        exit 102;
    }
    else {
        print "[*] Curl is installed\n";
        print GREEN, "[*]\n", RESET
    }

    return 1;
}

sub install_xcode_tools {
    print GREEN, "[*] Checking for XCode Commandline Tools\n", RESET;

    my $xcode_binary = system("xcode-select -v &> /dev/null");
    my $xcode_installer = system("xcode-select --install &> /dev/null");


    if ( $xcode_binary != 0 ) {
        print "[*] XCode Commandline tools are required\n";
        print "[*] Installing XCode Commandline tools\n";
        print GREEN, "[*]";

        if ( $xcode_installer != 0) {
             print RED, "[*] XCode Commandline Tools failed to installed\n";
            exit 103;
        }
    }

    print "[*] XCode Commandline tools are installed\n";
    print GREEN, "[*]\n";
}

# This gathers basic info, performs any setup configurations and makes sure any script dependencies
# are met.
sub initialize {
    print BLUE, "[*]<-----------------INITIALIZATION----------------->\n", RESET;
    print GREEN, "[*]\n", RESET;

    unless(check_binaries()) {
        print RED, "Checking for binaries failed", RESET;
        exit 104;
    }

    unless(enable_sudo()) {
        print RED, "Privilage escalation failed", RESET;
        exit 105;
    }

    unless(install_xcode_tools()) {
        print RED, "Installation of XCode Commandline Tools failed", RESET;
        exit 106;
    }

    unless(create_config_directories()) {
        print RED, "Creating baseline config directories failed", RESET;
        exit 107;
    }
}

##---------------------- Install Homebrew --------------------##  DIDN'T GO FURTHER

# We check to see if homebrew is installed and if not then we install it. After it completes
# we install the brewfile and install all programs contained in it.

sub install_homebrew {
    print GREEN, "[*] Checking for Homebrew\n", RESET;
    print GREEN, "[*]\n", RESET;

    my $brew_binary = system("brew -v &> /dev/null");

    if ( $brew_binary != 0 ) {
        print "[*] Homebrew is required\n";
        print "[*] Installing Homebrew\n";
        print GREEN, "[*]";

        if ( $xcode_installer != 0) {
             print RED, "[*] XCode Commandline Tools failed to installed\n";
            exit 103;
        }
    }



  echo "Checking homebrew"
  if [ -n "$(brew -v)" ]; then
    echo "Installing Homebrew..."
    sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    echo "Homebrew is already installed"
  fi

  install_brewfile

  return 0
}
  echo "Checking homebrew"
  if [ -n "$(brew -v)" ]; then
    echo "Installing Homebrew..."
    sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    echo "Homebrew is already installed"
  fi

  install_brewfile

  return 0


sub install_homebrew {

    print BLUE, "[*]<-----------------HOMEBREW----------------->\n", RESET;
    print GREEN, "[*]\n", RESET;

    install_homebrew()
}

# Link the Brewfile and install all packages. We also run cleanup after
# to generate a list of debis that should be removed, the actual removal
# is a manual process to provide for a sanity check.
install_brewfile() {
  brew_file="$HOME/Brewfile"

  if [ ! -f "$brew_file" ]; then
    echo "Linking brewfile"
    ln -s "$cwd/homebrew/Brewfile" "$brew_file"
  else
    echo "Brewfile already linked"
  fi

  echo "Updating Homebrew package list"
  if brew update --force >/dev/null; then
    echo "Homebrew was updated successfully"
  else
    echo "'brew update' failed"
    exit 1

  fi

  echo "Upgrading Homebrew package list"
  if brew upgrade >/dev/null; then
    echo "Homebrew was upgraded successfully"
  else
    echo "'brew upgrade' failed"
    exit 1
  fi

  echo "Installing new homebrew packages"
  if brew bundle install --file "$brew_file" >/dev/null; then
    echo "All Homebrew packages were installed successfully"
  else
    echo "'brew bundle install' failed"
    exit 1
  fi

  echo "Running a cleanup of Homebrew"
  if brew cleanup > "$HOME/Desktop/brew_cleanup"; then
    echo "Homebrew cleanup list was created successfully"
  else
    echo "'brew cleanup' failed"
    exit 1
  fi

  echo "Homebrew Installation Complete"

  return 0
}

sub run {

    unless(initialize()) {
        print "Initilaztion failed";
        exit 108;
    }

}

run();