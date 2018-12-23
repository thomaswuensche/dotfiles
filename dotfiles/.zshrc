# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/thomas/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="twue"
#ZSH_THEME="bullet-train"
#ZSH_THEME="agnoster"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  rails
  brew
  osx
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="atom ~/.zshrc"
alias zshtheme="atom ~/.oh-my-zsh/themes/twue.zsh-theme"
alias ohmyzsh="atom ~/.oh-my-zsh"
alias karabinerconfig="atom ~/.config/karabiner/karabiner.json"
alias mst="mysql.server status"
alias msr="mysql.server start"
alias msp="mysql.server stop"
alias mv="mv -i -v"
alias cp="cp -i -v"
alias lar="ls -lart"
alias lq="tree -a -I '.git|*org.eclipse*'"
alias python="python3"
alias pip="pip3"
alias findhere="find . -iname"
alias findregex="find . -iregex"
alias gl="git log"
alias -g icloud="/Users/thomas/Library/Mobile\ Documents/com~apple~CloudDocs"
alias -g htdocs="/Applications/XAMPP/xamppfiles/htdocs/web-tech"
***REMOVED***
alias fetchcred="cp ~/coding/htw-berlin/DbCred.java ~/coding/htw-berlin/db-tech/code/dbtech_service/src/main/java/de/htwberlin/utils && cp ~/coding/htw-berlin/DbCred.java ~/coding/htw-berlin/db-tech/code/dbtech_jdbc/src/main/java/de/htwberlin/utils"

# ignores previous cp alias
alias deploy="command cp -v -R"

# python enviroments
alias web-crawler-pyenv="source ~/coding/python-env/web-crawler-pyenv/bin/activate"
alias spotipy3-pyenv="source ~/coding/python-env/spotipy3-pyenv/bin/activate"

eval "$(rbenv init -)"

export NVM_DIR="$HOME/.nvm"
  . "/usr/local/opt/nvm/nvm.sh"

export VIRTUAL_ENV_DISABLE_PROMPT=1
export LSCOLORS="Fxfxcxdxbxegedabagacad"
# export LESS="z15" -- causes colored output to be scrambled -> only append -z15?

stty -ixon
stty ixany
