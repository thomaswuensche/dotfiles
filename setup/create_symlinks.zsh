function delete_prompt() {
  echo -en "overwrite \033[0;34m$1\033[0m ? "
  read user_input
  if [[ $user_input == 'y' ]]; then
    return 0
  else
    return 1
  fi
}

function create_file_symlink() {
  if [[ -e $2 && ! -h $2 ]]; then
    delete_prompt $2
    if [[ $? -eq 0 ]]; then
      rm $2
      command ln -sfhv $1 $2
    fi
  else
    command ln -sfhv $1 $2
  fi
}

function create_dir_symlink() {
  if [[ -d $2 && ! -h $2 ]]; then
    delete_prompt $2
    if [[ $? -eq 0 ]]; then
      rm -rf $2
      command ln -sfhv $1 $2
    fi
  else
    command ln -sfhv $1 $2
  fi
}

# files
create_file_symlink ~/coding/dotfiles/zsh/thowue.zsh-theme ~/.oh-my-zsh/themes/thowue.zsh-theme
create_file_symlink ~/coding/dotfiles/zsh/zshrc ~/.zshrc
create_file_symlink ~/coding/dotfiles/vim/vimrc ~/.vimrc
create_file_symlink ~/coding/dotfiles/pry/pryrc ~/.pryrc
create_file_symlink ~/coding/dotfiles/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
create_file_symlink ~/coding/dotfiles/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
create_file_symlink ~/coding/dotfiles/git-settings/gitconfig ~/.gitconfig
create_file_symlink ~/coding/dotfiles/youtube-dl/config ~/.config/youtube-dl/config
create_file_symlink ~/coding/dotfiles/scripts/format_name.rb /usr/local/bin/format-name
create_file_symlink ~/coding/dotfiles/source-highlight/esc.style /usr/local/Cellar/source-highlight/3.1.9_4/share/source-highlight/esc.style
create_file_symlink ~/coding/dotfiles/source-highlight/ruby.lang /usr/local/Cellar/source-highlight/3.1.9_4/share/source-highlight/ruby.lang


# directories
create_dir_symlink ~/coding/dotfiles/atom ~/.atom
create_dir_symlink ~/coding/dotfiles/karabiner ~/.config/karabiner
create_dir_symlink ~/coding/dotfiles/vscode/snippets ~/Library/Application\ Support/Code/User/snippets
