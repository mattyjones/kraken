This uses [nord][1] for tmux
You need nord [dircolors][3]

Install [homebrew][2] and use my brewfile, make sure you make any changes before running this

Do not install anything by hand if you can help it, just use the brewfile allowing you to update as much of your entire system as possible  from a single command

this should be done with homebrew
I use [Fira Code][5] for everything and enable ligatures

Shell is hyper.js
The theme is [Nord][6]

Check the config file for a list of plugins enabled

git

gnugpg

homebrew

hyper

nvim

oh-my-zsh

osx

scripts

shell

starship

tmux

iterm can be used and the links are here for the theme, [nord][7]

should I do a single install script and then libraries for each, then I can pass in variables as needed

this will use realpath to get the full file path to the libraries. Need to fige this out in a more clean manner

Maybe just do an ls of the root and pull the config file from it


You will need to install the official vmware tools from the menu before doing anything. Then you can cut and paste this script in, pull the repo, or simply cut and paste the dotfiles you want

add sbin to the root path

add the default user to sudo

the script must be run as root if the user is not in the sudo group

we have an install script that does all the initial things and then maybe sets some kind of config file with varibales??

then we have an update script?

Could we just have some of the variables be env exports, such as the name and email in the git configs

we should add a doc on how to do this per repo but set the main one to what ever the user wants to set it to via commandline questions.

how do we deal with updates to the gitconfig, most likely the same as we do with the brew file, we could do a ifdef file
https://www.freecodecamp.org/news/how-to-handle-multiple-git-configurations-in-one-machine/
https://crunchify.com/how-to-set-github-user-name-and-user-email-per-repository-different-config-for-different-repository/
https://stackoverflow.com/questions/4220416/can-i-specify-multiple-users-for-myself-in-gitconfig

do we ask these questions ahead of time or now (email, username, etc
)


https://github.com/WillPower3309/awesome-dotfiles
https://github.com/lcpz/awesome-copycats
https://github.com/setkeh/Awesome
https://github.com/awesomeWM/awesome/issues/1395
https://wiki.archlinux.org/title/Awesome#Creating_the_configuration_file
https://awesomewm.org/apidoc/documentation/07-my-first-awesome.md.html
https://github.com/pw4ever/awesome-wm-config
https://wiki.ubuntu.com/LightDM
https://wiki.archlinux.org/title/LightDM
https://wiki.debian.org/LightDM
https://dev.to/l04db4l4nc3r/awesome-a-versatile-window-manager-4km2
https://github.com/awesomeWM/awesome

[1]: https://www.nordtheme.com/docs/ports/tmux/installation#manual
[2]: https://brew.sh
[3]: https://github.com/arcticicestudio/nord-dircolors
[5]: https://github.com/tonsky/FiraCode
[6]: https://github.com/arcticicestudio/nord-hyper
[7]: https://github.com/arcticicestudio/nord-iterm2