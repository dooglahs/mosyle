#!/bin/bash

# Setting use defaults for users that you do not want to set via a profile.
# For example, you might want to set the user's desktop picture, but using a profile the user
# cannot then change the desktop picture.

# USE:
# 1. Put all of the user space commands in the space _after_ the 'END'
# 2. Create a Custom Command in Mosyle and use your edited script, assign to computers, and save.

sudo -u $(stat -f "%Su" /dev/console) /bin/sh <<'END'

##########################################################################################
# Variables and stuff
##########################################################################################

USER_NAME=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ && ! /loginwindow/ { print $3 }' )
USER_PATH="/Users/${USER_NAME}"

# Insure System Preferences is closed so we can write to some of these
osascript -e 'tell application "System Preferences" to quit'
killall cfprefsd

##########################################################################################
# User space settings, running as the local user
##########################################################################################

# Set the Desktop Picture
osascript -e 'tell application "Finder" to set desktop picture to POSIX file "/Library/Desktop Pictures/Galaxy.jpg"'

# Unhide the various ~/Library folder
chflags nohidden "${USER_PATH}"/Library && xattr -d com.apple.FinderInfo  "${USER_PATH}"/Library