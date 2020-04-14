SEP=$'\ue0b0'

EXTRA_INFO_F_COLOR="252"
GIT_START_K_COLOR="239"
GIT_CLEAN_K_COLOR="022"
GIT_DIRTY_K_COLOR="088"
GIT_STAGE_K_COLOR="090"
GIT_COUNT_K_COLOR="096"
VENV_K_COLOR="237"
SFDX_K_COLOR="063"


PROMPT='
%B%F{245}%m: %F{070}$(pwd)%f%b
$(prompt_extra_info)%f%k$ '
# %F{252}$(git_prompt_info)%f%k$ '


# inserts separator and sets bacKground color until changed / reset
function insert_sep() {
  # if unset set to bacKground color (basically equals a space w/ K_COLOR)
  if [[ "$LAST_K_COLOR" == "" ]]; then
    $LAST_K_COLOR=$1
  fi
  echo "%F{$LAST_K_COLOR}%K{$1}$SEP%F{$EXTRA_INFO_F_COLOR}"
  $LAST_K_COLOR=$1
}

function prompt_extra_info() {
  HAS_EXTRA_INFO=false
  INFO="%F{$EXTRA_INFO_F_COLOR}"

  if in_git_repo; then
    INFO="${INFO}$(insert_sep $GIT_START_K_COLOR)git:$(git_branch_status)$(git_repo_status)"
    HAS_EXTRA_INFO=true
  fi

  if in_virtualenv; then
    INFO="${INFO}%K{$VENV_K_COLOR} ${VIRTUAL_ENV##*/}"
    HAS_EXTRA_INFO=true
  fi

  if in_sfdx_repo; then
    INFO="${INFO}$K{$SFDX_K_COLOR} $(sfdx_username)"
    HAS_EXTRA_INFO=true
  fi

  if [[ "$HAS_EXTRA_INFO" = true ]]; then
    echo "${INFO}%k%F{$LAST_K_COLOR}$SEP%f "
  fi
}

function git_prompt_info() {
  if [[ $(git symbolic-ref HEAD 2> /dev/null) ]]; then
    echo "$(prompt_virtualenv_git)%{%K{239}%} git:$(git_branch_status)$(git_repo_status) "
  else # not in git repo
    echo "$(prompt_virtualenv)"
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

function git_branch_status() {
  local remote ahead behind
  remote=${$(command git rev-parse --verify ${hook_com[branch]}@{upstream} --symbolic-full-name 2>/dev/null)/refs\/remotes\/}
  if [[ -n ${remote} ]]; then
      ahead=$(command git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
      behind=$(command git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)

      if [[ $ahead -gt 0 ]] && [[ $behind -eq 0 ]]; then
          git_commits_ahead
      elif [[ $behind -gt 0 ]] && [[ $ahead -eq 0 ]]; then
          git_commits_behind
      else
          echo "$(insert_sep $GIT_COUNT_K_COLOR)±0"
      fi
  else
      echo "$(insert_sep $GIT_COUNT_K_COLOR)!r"
  fi
}

function git_commits_ahead() {
  if command git rev-parse --git-dir &>/dev/null; then
    local commits="$(git rev-list --count @{upstream}..HEAD 2>/dev/null)"
    if [[ -n "$commits" && "$commits" != 0 ]]; then
      echo "$(insert_sep $GIT_COUNT_K_COLOR)+$commits"
    fi
  fi
}

function git_commits_behind() {
  if command git rev-parse --git-dir &>/dev/null; then
    local commits="$(git rev-list --count HEAD..@{upstream} 2>/dev/null)"
    if [[ -n "$commits" && "$commits" != 0 ]]; then
      echo "$(insert_sep $GIT_COUNT_K_COLOR)-$commits"
    fi
  fi
}

function git_repo_status() {
  local INDEX
  INDEX=$(command git status --porcelain -b 2> /dev/null)

  if $(echo "$INDEX" | grep '^A  ' &> /dev/null); then
    git_staged_status
  elif $(echo "$INDEX" | grep '^M  ' &> /dev/null); then
    git_staged_status
  elif $(echo "$INDEX" | grep '^MM ' &> /dev/null); then
    git_staged_status
  elif $(echo "$INDEX" | grep '^R  ' &> /dev/null); then
    git_staged_status
  elif $(echo "$INDEX" | grep '^D  ' &> /dev/null); then
    git_staged_status
  else
    git_dirty_status
  fi
}

function git_staged_status() {
  echo "$(insert_sep $GIT_STAGE_K_COLOR) ↑ $(current_branch) %{$reset_color%F{090}%}$SEP"
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
    echo "$(insert_sep $GIT_DIRTY_K_COLOR) + $(current_branch) %{$reset_color%F{088}%}$SEP"
  else
    echo "$(insert_sep $GIT_CLEAN_K_COLOR) $(current_branch) %{$reset_color%F{022}%}$SEP"
  fi
}

function sfdx_username() {
  echo "test-sfdx-username"
}

function in_git_repo() {
  if [[ $(git symbolic-ref HEAD 2> /dev/null) ]]; then
    return 0
  else
    return 1
  fi
}

function in_virtualenv() {
  if [[ -n "$VIRTUAL_ENV" && "$VIRTUAL_ENV_DISABLE_PROMPT" != true ]]; then
    return 0
  else
    return 1
  fi
}

function in_sfdx_repo() {
  if [[ -f "sfdx-project.json" ]]; then
    return 0
  else
    return 1
  fi
}
