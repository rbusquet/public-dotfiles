#!/bin/bash
set -e

cp -r . $HOME
rm -rf $HOME/.git

if [[ ! -a $HOME/.oh-my-zsh ]]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if [[ ! -a $HOME/.fzf ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    $HOME/.fzf/install --all
fi

if [[ ! -a $HOME/.go ]]; then
    curl -L https://git.io/vQhTU | GOROOT=$HOME/.go bash
fi

if [[ ! -a $HOME/.nvm ]]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | NVM_DIR=$HOME/.nvm bash
fi

if [[ ! -a $GOPATH/bin/powerline-go ]]; then
    export GOROOT=$HOME/.go
    export PATH=$GOROOT/bin:$PATH
    export GOPATH=$HOME/go
    export PATH=$GOPATH/bin:$PATH
    go install github.com/justjanne/powerline-go@latest
fi