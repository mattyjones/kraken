#!/bin/bash

install_browsers() {
  local pkgs=("firefox" "chrome")
  package_install "${pkgs[@]}"
  
}

install_network_tools() {
local pkgs=("openconnect")
package_install "${pkgs[@]}"

}

# configure firefox
# configure chrome
# can I get te vpn file from htb via api

# can I do something like pull specific funstions for groups into other profiles.
# Ex. install_browsers, only