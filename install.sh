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

if [[ ! -a $HOME/.nvm ]]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | NVM_DIR=$HOME/.nvm bash
fi

# git config
git config --global user.name "Ricardo Busquet"
git config --global user.email 7198302+rbusquet@users.noreply.github.com
git config --global pull.rebase true
git config --global alias.fprune "fetch origin --prune"
git config --global alias.undo "reset HEAD~"
