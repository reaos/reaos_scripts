#!/bin/sh
# If reaostf-adb container is running, use its adb
container_id=$(docker ps -q -f name=reaostf-adb | head -n 1)
if [ -n "$container_id" ]; then
    alias adb='docker exec -it $container_id adb'
fi

# If first argument is "bshell", run adb shell command on all devices
if [ "$1" = 'bshell' ]; then
    shift

    # Check if the user provided a command
    if [ -z "$1" ]; then
        echo "Usage: adb bshell <command>"
        exit 1
    fi

    # Run the command on all connected devices
    devices=$(adb devices | awk 'NR>1 && /device/ {print $1}')
    for device in $devices; do
        echo "Running command on device: $device"
        adb -s $device shell "$@"
    done
else
  # Compatibility with the original adb command
  adb "$@"
fi