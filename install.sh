#!/usr/bin/env zsh
set -e

cp -r . $HOME
rm -rf $HOME/.git

if [[ ! -a $HOME/.oh-my-zsh ]]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

. $HOME/.zshrc


if [[ ! -a $HOME/.fzf ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    $HOME/.fzf/install --all
fi

if [[ ! -a $HOME/.go ]]; then
    curl -L https://git.io/vQhTU | GOROOT=$HOME/.go zsh
fi

if [[ ! -a $HOME/.nvm ]]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | NVM_DIR=$HOME/.nvm zsh
fi

if [[ ! -a $GOPATH/bin/powerline-go ]]; then
    go install github.com/justjanne/powerline-go@latest
fi
