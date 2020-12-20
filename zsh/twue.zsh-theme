SEP=$'\ue0b0'

EXTRA_INFO_F_COLOR="252"
GIT_START_K_COLOR="239"
GIT_CLEAN_K_COLOR="022"
GIT_DIRTY_K_COLOR="088"
GIT_STAGE_K_COLOR="090"
GIT_COUNT_K_COLOR="096"
GIT_HEROKU_K_COLOR="020"
GIT_STASH_K_COLOR="184"
GIT_STASH_F_COLOR="000"
VENV_K_COLOR="196"
SFDX_K_COLOR="054"


PROMPT='
%B%F{245}%m: %F{070}$(pwd)%f%b
$(prompt_extra_info)%f%k$ '


# inserts separator and sets bac(K)ground color until changed
function insert_sep() {
  if [[ -n $LAST_K_COLOR ]]; then
    echo -n "%F{$LAST_K_COLOR}%K{$1}$SEP%F{$EXTRA_INFO_F_COLOR}"
  else
    echo -n "%K{$1} %F{$EXTRA_INFO_F_COLOR}"
  fi
  LAST_K_COLOR=$1
}

function prompt_extra_info() {
  HAS_EXTRA_INFO=false

  if in_git_repo; then
    git_start
    git_branch_status
    git_heroku_status
    git_stash_status
    git_repo_status
    HAS_EXTRA_INFO=true
  fi

  if in_virtualenv; then
    insert_sep $VENV_K_COLOR
    echo -n " ${VIRTUAL_ENV##*/} "
    HAS_EXTRA_INFO=true
  fi

  if in_sfdx_repo; then
    insert_sep $SFDX_K_COLOR
    sfdx_username
    HAS_EXTRA_INFO=true
  fi

  if [[ $HAS_EXTRA_INFO = true ]]; then
    echo -n "%k%F{$LAST_K_COLOR}$SEP%f "
  fi
}

function git_start() {
  insert_sep $GIT_START_K_COLOR
  echo -n "git:"
}

function git_branch_status() {
  local remote ahead behind
  remote=${$(command git rev-parse --verify ${hook_com[branch]}@{upstream} --symbolic-full-name 2>/dev/null)/refs\/remotes\/}
  if [[ -n ${remote} ]]; then
    ahead=$(command git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
    behind=$(command git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)

    if [[ $ahead -ne 0 || $behind -ne 0 ]]; then
      insert_sep $GIT_COUNT_K_COLOR
      if [[ $ahead -gt 0 && $behind -eq 0 ]]; then
        git_commits_ahead
      elif [[ $behind -gt 0 && $ahead -eq 0 ]]; then
        git_commits_behind
      else
        echo -n "-<"
      fi
    fi
  else
    insert_sep $GIT_COUNT_K_COLOR
    echo -n "!r"
  fi
}

function git_heroku_status() {
  local heroku_remote ahead
  heroku_remote=$(git remote | grep heroku)
  if [[ -n $heroku_remote ]]; then
    ahead=$(git rev-list heroku/$(git_main_branch)..$(git_main_branch) 2> /dev/null | wc -l)
    if [[ $ahead -gt 0 ]]; then
      insert_sep $GIT_HEROKU_K_COLOR
      echo -n '+h'
    fi
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

function git_stash_status() {
  if [[ -n "$(git stash list)" ]]; then
    insert_sep $GIT_STASH_K_COLOR
    echo -n "%F{black}≡%F{$EXTRA_INFO_F_COLOR}"
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
  insert_sep $GIT_STAGE_K_COLOR
  echo -n " ↑ $(current_branch) "
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
    insert_sep $GIT_DIRTY_K_COLOR
    echo -n " + $(current_branch) "
  else
    insert_sep $GIT_CLEAN_K_COLOR
    echo -n " $(current_branch) "
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
  if [[ -n $VIRTUAL_ENV ]]; then
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
