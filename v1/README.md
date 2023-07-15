This uses [nord][1] for tmux You need nord [dircolors][3]

Install [homebrew][2] and use my brewfile, make sure you make any changes before running this

Do not install any apps by hand if you can help it, just use the brewfile allowing you to update as much of your entire
system as possible from a single command

this should be done with homebrew I use [Fira Code][5] for everything and enable ligatures

Could I just have some of the variables be env exports, such as the name and email in the git configs


how do we deal with updates to the gitconfig, most likely the same as we do with the brew file, we could do a ifdef file
https://www.freecodecamp.org/news/how-to-handle-multiple-git-configurations-in-one-machine/
https://crunchify.com/how-to-set-github-user-name-and-user-email-per-repository-different-config-for-different-repository/
https://stackoverflow.com/questions/4220416/can-i-specify-multiple-users-for-myself-in-gitconfig

do we ask these questions ahead of time or now (email, username, etc)

colored output

use printf instead of echo where it makes sense

bring all stderr to the screen

https://github.com/VundleVim/Vundle.vim
https://www.atlassian.com/git/tutorials/dotfiles
https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789
https://drewdevault.com/2019/12/30/dotfiles.html
https://www.anishathalye.com/2014/08/03/managing-your-dotfiles/
https://abdullah.today/encrypted-dotfiles/
https://dotfiles.github.io/inspiration/
http://gully.github.io/2015/11/15/brews_gems_dotfiles_conda_installing_on_mac/
https://dotfiles.github.io/inspiration/
https://www.twilio.com/blog/using-dotfiles-productivity-bootstrap-systems

.gemrc
.bundle



Can we do a remote install
sh -c "`curl -fsSL https://raw.github.com/webpro/dotfiles/master/remote-install.sh`"

https://driesvints.com/blog/getting-started-with-dotfiles/
https://github.com/holman/dotfiles

# lots of mac configs
https://github.com/mathiasbynens/dotfiles/blob/master/.macos 

# Huge brewfile
https://github.com/driesvints/dotfiles/blob/main/Brewfile

https://github.com/mathiasbynens/dotfiles/blob/master/.macos
https://github.com/thoughtbot/dotfiles

# Dotfiles
https://github.com/aaronbates/dotfiles

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
