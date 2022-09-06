#! /bin/env bash

source util.sh

# TODO complete the system file

# TODO change the sources to testing after asking
# TODO perform a dist-upgrade
# TODO Upgrade and update should be unattended via a flag if necessary
# TODO set the updates to be unattened if requested. This shoul tie into a global system variable

# system_upgrade will update the package lists and any packages that are already installed to
# the latest versions. This update is based on the source branch set in set_debian_source()
system_upgrade() {
  if [ ! "$(sudo apt-get update && sudo apt-get upgrade)" ]; then
    echo -e "\n\e[$red System upgrade failed\e[$default"
    echo ""
    return 1
  else
    echo -e "\n\e[$cyan System update complete\e[$default"
    echo ""
    return 0
  fi

  # Return 1 by default as a defensive measure of an unknown failure
  return 1
}

# set_debian_source will change the release branch {bullseye, testing, unstable} to the requested branch
set_debian_source() {

  local new_branch="$1"
  # shellcheck disable=2155
  # FIXME SC2002
  local current_branch=$(cat /etc/apt/sources.list | grep -m 1 "deb http://" | awk '{ print $3 }')

  if [ "$current_branch" == "$new_branch" ]; then
    echo "Release branch is already set to $new_branch"
    return 0
  else
    echo "Setting release branch to $new_branch"
    sudo sed -i "s/$current_branch/$new_branch/g" /etc/apt/sources.list
  fi

  if [ "$current_branch" != "$new_branch" ]; then
    echo -e "\n\e[$red Changing release branch failed\e[$default"
    return 1
  else
    return 0
  fi

  # Return 1 by default as a defensive measure of an unknown failure
  return 1
}

