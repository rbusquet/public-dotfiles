export ZSH=$HOME/.oh-my-zsh
export FZF_BASE=$HOME/.fzf
ZSH_THEME=minimal

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# oh-my-zsh
plugins=(git fzf python gh)

source $ZSH/oh-my-zsh.sh

# code completition
[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh

alias ohmyzsh="code $HOME/.oh-my-zsh"

ghclone() {
    OWNER=${1:-rbusquet}
    REPO=$(gh repo list "$OWNER" --json name -q ".[].name" --limit 900 | fzf --header 'Select repository to clone' --layout=reverse)
    [[ "$REPO" != "" ]] && gh repo clone "$OWNER"/${REPO} || echo "won't clone"
}

agg() {
    INITIAL_QUERY=""
    RG_PREFIX="ag --column --line-number --no-heading --color --smart-case "
    FZF_DEFAULT_COMMAND="$RG_PREFIX '$INITIAL_QUERY'" \
        fzf --bind "change:reload:$RG_PREFIX {q} || true" \
        --ansi --disabled --query "$INITIAL_QUERY" \
        --height=50% --layout=reverse
}

export PATH="$HOME/bin:$PATH"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
