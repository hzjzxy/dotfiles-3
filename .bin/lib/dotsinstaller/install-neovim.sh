#!/bin/bash

set -ue

source $(dirname "${BASH_SOURCE[0]:-$0}")/utilfuncs.sh

# stable
if ! builtin command -v nvim > /dev/null 2>&1; then
  checkinstall neovim
fi

# nightly
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
chmod u+x nvim.appimage
sudo mv nvim.appimage /usr/local/bin
sudo ln -snf /usr/local/bin/nvim.appimage /usr/local/bin/nvim

distro=`whichdistro`
if [[ $distro == "redhat" ]];then
  sudo python3 -m pip install pynvim || true
  curl -sL install-node.now.sh/lts | sudo bash -s -- -f # coc.nvim
elif [[ $distro == "arch" ]];then
  sudo pacman -S --noconfirm --needed python-neovim
  checkinstall nodejs # coc.nvim

  # sudo pacman -S --noconfirm --needed fuse
  # sudo modprobe fuse
  # sudo groupadd fuse
  # user="$(whoami)"
  # sudo usermod -a -G fuse $user
elif [[ $distro == "alpine" ]];then
  sudo apk add python3 gcc libc-dev procps perl ncurses coreutils python3-dev
  sudo python3 -m pip install pynvim
  checkinstall nodejs yarn npm # coc.nvim
else
  sudo pip install pynvim
  curl -sL install-node.now.sh/lts | sudo bash -s -- -f # coc.nvim
fi

