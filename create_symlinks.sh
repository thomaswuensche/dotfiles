# files
command ln -sfhv ~/coding/dotfiles/zsh/thowue.zsh-theme ~/.oh-my-zsh/themes/thowue.zsh-theme
command ln -sfhv ~/coding/dotfiles/zsh/zshrc ~/.zshrc
command ln -sfhv ~/coding/dotfiles/vim/vimrc ~/.vimrc
command ln -sfhv ~/coding/dotfiles/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
command ln -sfhv ~/coding/dotfiles/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
command ln -sfhv ~/coding/dotfiles/git-settings/gitconfig ~/.gitconfig
command ln -sfhv ~/coding/dotfiles/youtube-dl/config ~/.config/youtube-dl/config

chmod +x ~/coding/dotfiles/scripts/format-name.rb
command ln -sfhv ~/coding/dotfiles/scripts/format-name.rb /usr/local/bin/format-name


# directories
function create_dir_symlink() {
  if [[ -d $2 && ! -h $2 ]]; then
    echo 'deleted:'
    rm -rfv $2
  fi
  command ln -sfhv $1 $2
}

create_dir_symlink ~/coding/dotfiles/atom ~/.atom
create_dir_symlink ~/coding/dotfiles/karabiner ~/.config/karabiner
create_dir_symlink ~/coding/dotfiles/vscode/snippets ~/Library/Application\ Support/Code/User/snippets
