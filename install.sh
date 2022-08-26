#!/usr/bin/env bash
set -e

pip install powerline-shell

if [[ ! -a $HOME/.oh-my-zsh ]]; then  
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
