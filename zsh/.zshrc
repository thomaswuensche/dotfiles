# path to oh-my-zsh installation
export ZSH="/Users/thomas/.oh-my-zsh"

ZSH_THEME="twue"

plugins=(
  git
  rails
  brew
  osx
)

source $ZSH/oh-my-zsh.sh


# --- builtin ---
alias mv="mv -i -v"
alias cp="cp -i -v"
alias deploy="command cp -v -R"
alias lar="ls -lart"
alias lq="tree -a -L 3 -I '.git|*org.eclipse*'"
alias findhere="find . -iname"
alias findregex="find . -iregex"
alias restart="exec $SHELL"
alias type="type -a"
alias which="which -a"


# --- dotfiles ---
alias ohmyzsh="atom ~/.oh-my-zsh"
alias zshconfig="atom ~/.zshrc"
alias zshtheme="atom ~/.oh-my-zsh/themes/twue.zsh-theme"
alias karabinerconfig="atom ~/.config/karabiner/karabiner.json"


# --- config savers ---
alias apmlist="apm list -ib > ~/coding/dotfiles/atom/apmList.txt"
alias brewlist="brew list --versions > ~/coding/dotfiles/cellar/brewList.txt"
alias codelist="code --list-extensions --show-versions > ~/coding/dotfiles/vscode/extensionList.txt"


# --- git ---
alias gl="git log"
alias gdh="git diff HEAD --stat -p"
alias gdhs="git diff HEAD --staged"
alias grh="git reset HEAD"
alias grc="git checkout -- ."
alias gfv="git fetch -v"
alias gls="git log --stat"
alias glg="git log --all --decorate --oneline --graph"
alias gs="git stash"


# --- db ---
alias mst="mysql.server status"
alias msr="mysql.server start"
alias msp="mysql.server stop"

alias pgc="pg_ctl"
alias pst="pg_ctl status"
alias psr="pg_ctl start"
alias psp="pg_ctl stop"

function psql-heroku() {
  local DATABASE_URL="$(heroku config:get DATABASE_URL)"
  if [[ $DATABASE_URL == postgres://* ]]; then
    psql $DATABASE_URL
  else
    echo "failed to retrieve heroku DATABASE_URL config var"
  fi
}

export PGDATA="/usr/local/var/postgres"


# --- rails ---
alias rt="rails test"


# --- sfdx ---
alias sfdxallmd="sfdx force:source:retrieve -x ~/coding/salesforce/package.xml --verbose"
alias sfdxcode="sfdx force:source:retrieve -x ~/coding/salesforce/apex.xml --verbose"


# --- misc ---
function setenv() {
  set -a
  source .env
  set +a

  if [[ $HEROKU_PG_DB ]]; then
    export DATABASE_URL="$(heroku config:get DATABASE_URL)"
  fi
}

alias -g icloud="/Users/thomas/Library/Mobile\ Documents/com~apple~CloudDocs"
alias isbrew="la /usr/local/bin | grep"
alias at="atom ."

eval "$(rbenv init -)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

export VIRTUAL_ENV_DISABLE_PROMPT=1
export LSCOLORS="Fxfxcxdxbxegedabagacad"

# Disable START/STOP output control.
stty -ixon
