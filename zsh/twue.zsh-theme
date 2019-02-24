SEP=$'\ue0b0'

PROMPT='
%{%B%F{245}%}%m: %{%F{070}%}$(pwd)%{$reset_color%}%{%b%}
%{%F{252}%}$(git_prompt_info)%{$reset_color%}$ %{%f%k%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{%K{239}%} git:"
ZSH_THEME_GIT_PROMPT_SUFFIX=" "

function get_pwd() {
  echo "${PWD/$HOME/~}"
}

function git_prompt_info() {
  if [[ $(git symbolic-ref HEAD 2> /dev/null) ]]; then
    echo "$(prompt_virtualenv_git)$ZSH_THEME_GIT_PROMPT_PREFIX$(git_branch_status)$(git_repo_status)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  else # not in git repo
    echo "$(prompt_virtualenv)"
  fi
  # ref=$(git symbolic-ref HEAD 2> /dev/null) || return
}

function git_repo_status() {
  local INDEX
  INDEX=$(command git status --porcelain -b 2> /dev/null)

  if $(echo "$INDEX" | grep '^A  ' &> /dev/null); then
    echo "%{%K{090}%F{096}%}$SEP%{%F{252}%} ↑ $(current_branch) %{$reset_color%F{090}%}$SEP"
  elif $(echo "$INDEX" | grep '^M  ' &> /dev/null); then
    echo "%{%K{090}%F{096}%}$SEP%{%F{252}%} ↑ $(current_branch) %{$reset_color%F{090}%}$SEP"
  elif $(echo "$INDEX" | grep '^MM ' &> /dev/null); then
    echo "%{%K{090}%F{096}%}$SEP%{%F{252}%} ↑ $(current_branch) %{$reset_color%F{090}%}$SEP"
  elif $(echo "$INDEX" | grep '^D  ' &> /dev/null); then
    echo "%{%K{090}%F{096}%}$SEP%{%F{252}%} ↑ $(current_branch) %{$reset_color%F{090}%}$SEP"
  else
    echo "$(git_dirty_status)"
  fi
}

function prompt_virtualenv() {
  if [[ -n "$VIRTUAL_ENV" && "$VIRTUAL_ENV_DISABLE_PROMPT" != true ]]; then
    echo "%{%K{237}%} ${VIRTUAL_ENV##*/} %{$reset_color%F{237}%}$SEP "
  fi
}

function prompt_virtualenv_git() {
  #in git AND venv
  if [[ -n "$VIRTUAL_ENV" && "$VIRTUAL_ENV_DISABLE_PROMPT" != true ]]; then
    echo "%{%K{237}%} ${VIRTUAL_ENV##*/} %{%K{239}%F{237}%}$SEP%{%F{252}%}"
  fi
}

function git_dirty_status() {
  local STATUS=''
  local -a FLAGS
  FLAGS=('--porcelain')
  if [[ "$(command git config --get oh-my-zsh.hide-dirty)" != "1" ]]; then
    if [[ $POST_1_7_2_GIT -gt 0 ]]; then
      FLAGS+='--ignore-submodules=dirty'
    fi
    if [[ "$DISABLE_UNTRACKED_FILES_DIRTY" == "true" ]]; then
      FLAGS+='--untracked-files=no'
    fi
    STATUS=$(command git status ${FLAGS} 2> /dev/null | tail -n1)
  fi
  if [[ -n $STATUS ]]; then
    echo "%{%K{088}%F{096}%}$SEP%{%F{252}%} + $(current_branch) %{$reset_color%F{088}%}$SEP"
  else
    echo "%{%K{022}%F{096}%}$SEP%{%F{252}%} $(current_branch) %{$reset_color%F{022}%}$SEP"
  fi
}

function git_branch_status() {
  local remote ahead behind
  remote=${$(command git rev-parse --verify ${hook_com[branch]}@{upstream} --symbolic-full-name 2>/dev/null)/refs\/remotes\/}
  if [[ -n ${remote} ]]; then
      ahead=$(command git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
      behind=$(command git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)

      if [[ $ahead -gt 0 ]] && [[ $behind -eq 0 ]]; then
          echo $(git_commits_ahead)
      elif [[ $behind -gt 0 ]] && [[ $ahead -eq 0 ]]; then
          echo $(git_commits_behind)
      else
          echo "%{%K{096}%F{239}%}$SEP%{%F{252}%}±0"
      fi
  else
      echo "%{%K{096}%F{239}%}$SEP%{%F{252}%}!r"
  fi
}

function git_commits_ahead() {
  if command git rev-parse --git-dir &>/dev/null; then
    local commits="$(git rev-list --count @{upstream}..HEAD 2>/dev/null)"
    if [[ -n "$commits" && "$commits" != 0 ]]; then
      echo "%{%K{096}%F{239}%}$SEP%{%F{252}%}+$commits"
    fi
  fi
}

function git_commits_behind() {
  if command git rev-parse --git-dir &>/dev/null; then
    local commits="$(git rev-list --count HEAD..@{upstream} 2>/dev/null)"
    if [[ -n "$commits" && "$commits" != 0 ]]; then
      echo "%{%K{096}%F{239}%}$SEP%{%F{252}%}-$commits"
    fi
  fi
}
