  git clone https://github.com/alacritty/alacritty.git /tmp/alacritty
  cd /tmp/alacritty || return 1
  cargo build --release
  cd target/release || return 1
  sudo  mv alacritty /usr/local/bin
  sudo rm -rf /tmp/alacritty
