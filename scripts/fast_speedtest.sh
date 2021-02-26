date=$(date)
result=$(/usr/local/bin/fast --upload)

if [[ $1 == '--lan' ]]; then
  mode="LAN"
else
  mode="WIFI"
fi

echo "\n$date\n$mode\n$result" >> "$LOGS_DIR/speedtests.log"
