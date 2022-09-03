sudo apt install curl git cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

source $HOME/.cargo/env

rustup override set stable

rustup update stable

git clone https://github.com/alacritty/alacritty.git

cd alacritty

cargo build --release

cd target/release

mv alacritty /usr/local/bin

