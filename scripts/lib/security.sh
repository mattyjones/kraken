
##---------------------- GPG Configuration --------------------##

# TODO Do something with this at some point
configure_gpg() {
  #  ln -s "$cwd/gnupg/gpg-agent.conf $HOME/.gnupg/gpg-agent.conf

  return 0
}

create_ssh_keys() {
  echo "Create SSH keys for use with github"

  ssh-keygen
}



# TODO where do I put the dir creation bits security, development, main, ??
