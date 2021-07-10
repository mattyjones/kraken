#!/usr/bin/perl

#
#  kraken
#
# AUTHOR: Matt Jones
#
# DESCRIPTION:
#    Kraken is a semi-automated, opinionated environment configuration tool. 
#    Application and tool specific configurations are easy to modify. All tools
#    are built and installed as isolated as possible to ensure compostability
#    and user specific tastes. 
#
# OUTPUT:
#    plain-text
#
# PLATFORMS:
#    OSX
#
# DEPENDENCIES:
#    Perl Standard Library
#
# USAGE:
#
# NOTES:
#   
# LICENSE: 
#    MIT
#

use warnings;
use strict;

use Term::ANSIColor qw(:constants);
use Getopt::Long qw(GetOptions);
use Cwd qw(getcwd);

local $Term::ANSIColor::AUTORESET = 1;

my $DEBUG = 0;
my $SILENT = 0;
my $COMMAND = "kracken";
my $BASE_DIR = getcwd();
my $VERSION = "0.0.1";

my $arch_ver = `sw_vers | grep ProductVersion | awk '{print $$2 }'`;
my $arch = `uname`;

chomp($arch);
chomp($arch_ver);

sub dep_checks {
    my $curl_binary = `which curl`;

    die "Please enter an IP range using the NMap format\n"
        unless defined($curl_binary);

}

sub initialize {

    my $usr_name = `logname`;
    my $usr_group = "staff";

    if ($arch eq "Darwin") {
        $usr_name = `logname`;
        $usr_group = "staff";
    }
    else {
        print RED, "This tool olny supports OSX/MacOS at this time\n";
        exit 1;
    }

    chomp($usr_name);
    chomp($usr_group);

    print CYAN, "[*]<------------------Initalize------------------>\n";
    print CYAN, "[*] ", RESET, "User:         $usr_name\n";
    print CYAN, "[*] ", RESET, "Group:        $usr_group\n";
    print CYAN, "[*] ", RESET, "OS:           $arch\n";
    print CYAN, "[*] ", RESET, "OS Version:   $arch_ver\n";
    print CYAN, "[*] ", RESET, "\n";
}

sub config_tmux {

}

sub config_shell {

}

sub config_starship {

}

sub config_git {

}

sub config_homebrew {
    my $cmd = `/bin/bash -c "\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/configure_osx.sh)" < /dev/null`;
    print $cmd;

    `brew bundle `
}

sub config_zsh {

}

sub config_nvim {

}
sub run {
    # print the logo
    logo();

    # check for any dependencies
    dep_checks();

    # initalize the world
    initialize();
}

sub logo {

    print RED, `echo " _              _          "`;
    print RED, `echo "| |            | |             "`;
    print RED, `echo "| | ___ __ __ _| | _____ _ __  "`;
    print RED, `echo "| |/ / '__/ _' | |/ / _ \\ '_ \\ "`;
    print RED, `echo "|   <| | | (_| |   <  __/ | | |"`;
    print RED, `echo "|_|\\_\\_|  \\__,_|_|\\_\\___|_| |_|"`;
    print `echo""`;
    print `echo""`;
}

run();

# print RED, "[*]<------------------Debug------------------>\n";
# print RED, "[*] ", RESET, "User:   $usr_name\n";
# print RED, "[*] ", RESET, "Group:  $usr_group\n";
# print RED, "[*] ", RESET, "Arch:   $arch\n";