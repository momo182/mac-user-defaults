#!/bin/bash

SRC=$HOME/Yandex.Disk.localized/img/wallz

# Set a custom wallpaper image. `DefaultDesktop.jpg` is already a symlink, and
# all wallpapers are in `/Library/Desktop Pictures/`. The default is `Wave.jpg`.
# https://discussions.apple.com/thread/3824777?tstart=0

find $SRC | sort -R | tail -1 | while read file; do
# echo "$file"
osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \""$file"\""
done