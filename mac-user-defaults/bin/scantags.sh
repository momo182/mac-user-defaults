#!/bin/bash

echo "### Scanning tags"
/usr/local/bin/tagfinder -root="/Users/momo/Dropbox/_markdown-storage/" 
/usr/local/bin/terminal-notifier -message "Finished tagfinder scan"