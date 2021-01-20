DOTFILES='/Users/thomas/coding/dotfiles'

function step() {
  echo '---'
  echo $1
}

echo 'init.zsh'

step 'running setup/chmods.zsh'
source "$DOTFILES/setup/chmods.zsh"

step 'running setup/create_symlinks.zsh'
source "$DOTFILES/setup/create_symlinks.zsh"

step 'setting crontab with contents of setup/cronjobs'
crontab "$DOTFILES/setup/cronjobs"
