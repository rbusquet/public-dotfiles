export ZSH=$HOME/.oh-my-zsh
export FZF_BASE=$HOME/.fzf

# oh-my-zsh
plugins=(git fzf python docker docker-compose gh)

source $ZSH/oh-my-zsh.sh

# code completition
[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh
[ -f $HOME/.devspace-completion ] && source $HOME/.devspace-completion

# aliases
alias k=kubectl
alias klogs="_klogs | sed 's/\\n/\n/g'"
alias ohmyzsh="code $HOME/.oh-my-zsh"
alias resolve="workspace/manage.py resolve"
alias runservice="docker-compose run --rm --service-ports"

# functions
compare() {
    if [ "$1" != "" ]; then
        gh pr create --web --base $1
    else
        gh pr create --web --base master
    fi
}

kbash() {
    POD=$(kubectl get po --output=name | fzf --header 'Select pod to attach' --layout=reverse)

    if [ "$POD" != "" ]; then
        CONTAINER=$(kubectl get ${POD} -o jsonpath='{.spec.containers[*].name}' | tr -s '[[:space:]]' '\n' | sort | uniq | fzf --header 'Select container' --layout=reverse)
    else
        echo "No pod selected"
    fi
    [[ "$CONTAINER" != "" ]] && kubectl exec -it ${POD} -c ${CONTAINER} -- bash || echo "won't run"
}

kdelete() {
    POD=$(kubectl get po --output=name | fzf --header 'Select pod to delete' --layout=reverse)
    [[ "$POD" != "" ]] && kubectl delete ${POD} || echo "won't run"
}

hdelete() {
    if [ "$1" = "all" ]; then
        echo "Deleting all releases"
        helm list --namespace ricardo-busquet -q | xargs -L1 -I % helm delete %
    else
        RELEASE=$(helm list --namespace ricardo-busquet -q | fzf --header 'Select release to delete' --layout=reverse)
        [[ "$RELEASE" != "" ]] && helm delete ${RELEASE} || echo "won't run"
    fi
}

_klogs() {
    POD=$(kubectl get po --output=name | fzf --header 'Select pod to attach' --layout=reverse)
    if [ "$POD" != "" ]; then
        CONTAINER=$(kubectl get ${POD} -o jsonpath='{.spec.containers[*].name}' | tr -s '[[:space:]]' '\n' | sort | uniq | fzf --header 'Select container' --layout=reverse)
    else
        echo "No pod selected"
    fi
    [[ "$CONTAINER" != "" ]] && kubectl logs -f ${POD} -c ${CONTAINER} || echo "won't run"
}

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

yubi() {
    YK_PREFIX="ykman oath accounts code "
    INITIAL_QUERY="$1"
    FZF_DEFAULT_COMMAND="$YK_PREFIX '$INITIAL_QUERY'" \
        fzf --bind "change:reload:$YK_PREFIX {q} || true" \
        --reverse --ansi --phony --query "$INITIAL_QUERY" \
        --prompt="$YK_PREFIX" | awk '{print $NF}' | pbcopy
}

source ~/bin/autovenv.sh

DISABLE_AUTO_UPDATE=true
DISABLE_UPDATE_PROMPT=true
export PATH=/home/vscode/.local/bin:$PATH

function powerline_precmd() {
    PS1="$(powerline-shell --shell zsh $?)"
}

function install_powerline_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

if [ "$TERM" != "linux" ]; then
    install_powerline_precmd
fi

if [ -e $HOME/.config/local.profile ]; then
    source $HOME/.config/local.profile
fi


export PATH="$HOME/bin:$PATH"
