
##---------------------- GPG Configuration --------------------##

#TODO Complete the security file

# TODO Do something with this at some point
configure_gpg() {
  #  ln -s "$cwd/gnupg/gpg-agent.conf $HOME/.gnupg/gpg-agent.conf

  return 0
}

create_ssh_keys() {
  echo "Create SSH keys for use with github"

  ssh-keygen
}

# install_tor will install the tor package. It will not enable/start it by default, that will need to be
# done on a manual basis. Browsers will not be configured automatically, only the tor service will be configured.
install_tor() {

  # placeholder

  return 0
}

# TODO where do I put the dir creation bits security, development, main, ??
