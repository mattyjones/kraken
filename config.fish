
## ALIASES ##

# Security
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"
alias pvtkey="more ~/.ssh/id_rsa | xclip -selection clipboard | echo '=> Private key copied to pasteboard.'"

# Networking
alias flush-dns='sudo killall -HUP mDNSResponder'
alias pubip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="sudo ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"
alias ips="sudo ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Development
alias ra="rubocop -a "
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

# System

# Applications

# Shell Commands
alias cls='clear'
alias cp='rsync --progress -avz'
alias ls='colorls -A'
alias grep='grep --color=auto '
alias untar='tar -xvzf'
alias kitty='bat'

# Configuration
alias editorcfg='vim ~/.editorconfig'


# Project Specific
alias golang='cd $GOPATH/src/'


