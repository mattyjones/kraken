#!/bin/bash

# TODO: Complete the networking file

install_browsers() {
  local pkgs=("firefox" "chromium")
  package_install "${pkgs[@]}"

  return 0

}

install_chat_programs() {
local pkgs=("irssi")
package_install "${pkgs[@]}"

return 0
}

install_network_tools() {
local pkgs=("openconnect" "inetutils" "tcpdump" "xfreerdp2-x11" "openvpn")
package_install "${pkgs[@]}"

return 0

}

networking_main() {
    install_browsers
    install_network_tools

    return 0
}

# TODO: add script to put the vpn info in a menu bar (HTB vs OffSec vs ??)

# TODO: configure firefox
# TODO: configure chrome
# TODO: can I get te vpn file from htb via api


