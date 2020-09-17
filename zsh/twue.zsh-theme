SEP=$'\ue0b0'

EXTRA_INFO_F_COLOR="252"
GIT_START_K_COLOR="239"
GIT_CLEAN_K_COLOR="022"
GIT_DIRTY_K_COLOR="088"
GIT_STAGE_K_COLOR="090"
GIT_COUNT_K_COLOR="096"
VENV_K_COLOR="196"
SFDX_K_COLOR="054"


PROMPT='
%B%F{245}%m: %F{070}$(pwd)%f%b
$(prompt_extra_info)%f%k$ '


# inserts separator and sets bac(K)ground color until changed / reset
function insert_sep() {
  local LAST_K_COLOR
  # if unset set to bac(K)ground color (basically equals a space w/ K_COLOR)
  if [[ "$1" == "none" ]]; then
    LAST_K_COLOR=$2
  else
    LAST_K_COLOR=$1
  fi
  echo -n "%F{$LAST_K_COLOR}%K{$2}$SEP%F{$EXTRA_INFO_F_COLOR}"
}

function prompt_extra_info() {
  HAS_EXTRA_INFO=false
  LAST_K_COLOR="none"

  if in_git_repo; then
    insert_sep $LAST_K_COLOR $GIT_START_K_COLOR
    echo -n "git:"
    insert_sep $GIT_START_K_COLOR $GIT_COUNT_K_COLOR
    git_branch_status
    git_repo_status
    HAS_EXTRA_INFO=true
  fi

  if in_virtualenv; then
    insert_sep $LAST_K_COLOR $VENV_K_COLOR
    echo -n " ${VIRTUAL_ENV##*/} "
    LAST_K_COLOR=$VENV_K_COLOR
    HAS_EXTRA_INFO=true
  fi

  if in_sfdx_repo; then
    insert_sep $LAST_K_COLOR $SFDX_K_COLOR
    sfdx_username
    LAST_K_COLOR=$SFDX_K_COLOR
    HAS_EXTRA_INFO=true
  fi

  if [[ "$HAS_EXTRA_INFO" = true ]]; then
    echo -n "%k%F{$LAST_K_COLOR}$SEP%f "
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
    elif [[ $behind -gt 0 ]] && [[ $ahead -gt 0 ]]; then
      echo -n "-<"
    else
      echo -n "±0"
    fi
  else
    echo -n "!r"
  fi
}

function git_commits_ahead() {
  if command git rev-parse --git-dir &>/dev/null; then
    local commits="$(git rev-list --count @{upstream}..HEAD 2>/dev/null)"
    if [[ -n "$commits" && "$commits" != 0 ]]; then
      echo -n "+$commits"
    fi
  fi
}

function git_commits_behind() {
  if command git rev-parse --git-dir &>/dev/null; then
    local commits="$(git rev-list --count HEAD..@{upstream} 2>/dev/null)"
    if [[ -n "$commits" && "$commits" != 0 ]]; then
      echo -n "-$commits"
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
  insert_sep $GIT_COUNT_K_COLOR $GIT_STAGE_K_COLOR
  echo -n " ↑ $(current_branch) "
  LAST_K_COLOR=$GIT_STAGE_K_COLOR
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
    insert_sep $GIT_COUNT_K_COLOR $GIT_DIRTY_K_COLOR
    echo -n " + $(current_branch) "
    LAST_K_COLOR=$GIT_DIRTY_K_COLOR
  else
    insert_sep $GIT_COUNT_K_COLOR $GIT_CLEAN_K_COLOR
    echo -n " $(current_branch) "
    LAST_K_COLOR=$GIT_CLEAN_K_COLOR
  fi
}

function sfdx_username() {
  config="$(cat .sfdx/sfdx-config.json)"
  defaultusername="$(echo ${config} | jq -r .defaultusername)"
  echo -n " ${defaultusername} "
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
