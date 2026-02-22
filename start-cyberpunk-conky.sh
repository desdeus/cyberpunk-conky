#!/bin/bash
# Gets the folder where the script itself resides
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Removes conky instances if present
killall conky
# Wait 10 seconds for the desktop to load in background
conky -d -p 10 -c "$DIR/cyberpunk-conky.conf" &
exit
