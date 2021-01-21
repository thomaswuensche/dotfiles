function step() {
  echo '---'
  echo $1
}

echo 'init.zsh'

step 'running setup/chmods.zsh'
source "setup/chmods.zsh"

step 'running setup/create_symlinks.zsh'
source "setup/create_symlinks.zsh"

step 'setting crontab with contents of setup/cronjobs'
crontab "setup/cronjobs"
