current_date=$(date +"%d_%m_%Y")

bookmarks_location="$HOME/Library/Application Support/BraveSoftware/Brave-Browser/Default/Bookmarks"
backup_location="$HOME/Library/Mobile Documents/com~apple~CloudDocs/backups/bookmarks/brave"

command cp -v $bookmarks_location "$backup_location/Bookmarks_$current_date.json" > /dev/null
