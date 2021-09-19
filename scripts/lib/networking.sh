#!/bin/bash

install_browsers() {
  local pkgs=("firefox" "chrome")
  package_install "${pkgs[@]}"

  return 0
  
}

install_network_tools() {
local pkgs=("openconnect")
package_install "${pkgs[@]}"

return 0

}

networking_main() {
    install_browsers
    install_network_tools

    return 0
}

# configure firefox
# configure chrome
# can I get te vpn file from htb via api

# can I do something like pull specific funstions for groups into other profiles.
# Ex. install_browsers, only