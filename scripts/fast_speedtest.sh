date=$(date)
result=$(/usr/local/bin/fast --upload)

echo "\n$date\n$result" >> "$LOGS_DIR/speedtests.log"
