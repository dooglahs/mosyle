#!/bin/bash

# Setting use defaults for users that you do not want to set via a profile.
# For example, you might want to set the user's desktop picture, but using a profile the user
# cannot then change the desktop picture.

# This version supports DEP for your first logged in enduser.

# USE:
# 1. Put all of the user space commands in the "User space settings" area
# 2. Create a Custom Command in Mosyle and use your edited script, assign to computers, under the
#	Schedule tab check "Upon Enrollment" and save.

# LOGIC:
# Create a LaunchAgent to launch a script on first user login;
# Script check for a file to exist; if it does not it creates file and applies settings;
#	if file does exist it exits.
# On next login the file will exist so the script will exit.

# LIMITATIONS
# Creates files that persist on the computer. This is not ideal.

##########################################################################################
# Create LaunchAgent to run script below on first login
##########################################################################################

cat > /Library/LaunchAgents/com.company.user_settings.plist <<LAUNCHAGENTS
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>com.company.user_settings</string>
	<key>Program</key>
	<string>/Users/Shared/.company_user_setting.sh</string>
	<key>RunAtLoad</key>
	<true/>
</dict>
</plist>
LAUNCHAGENTS
chmod 644 /Library/LaunchAgents/com.company.user_settings.plist
chown root:wheel /Library/LaunchAgents/com.company.user_settings.plist



##########################################################################################
# Write the script to disk so the LaunchAgent can run it
##########################################################################################

cat > /Users/Shared/.company_user_setting.sh <<XSCRIPT
#!/bin/bash

##########################################################################################
# First Pass at Script; if already done then skip
##########################################################################################

if [[ -e /Users/Shared/.company_user_setting.txt ]]; then
	FIRST_PASS_DONE="yes"
else
	touch /Users/Shared/.company_user_setting.txt
	FIRST_PASS_DONE="no"
fi

if [[ \${FIRST_PASS_DONE} = no ]]; then

##########################################################################################
# Variables and stuff
##########################################################################################

USER_NAME=\$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ && ! /loginwindow/ { print $3 }' )
USER_PATH="/Users/\${USER_NAME}"

# Insure System Preferences is closed so we can write to some of these
osascript -e 'tell application "System Preferences" to quit'
killall cfprefsd

##########################################################################################
# User space settings
##########################################################################################

# Set the Desktop Picture
osascript -e 'tell application "Finder" to set desktop picture to POSIX file "/Library/Desktop Pictures/Galaxy.jpg"'

# Unhide the various ~/Library folder
chflags nohidden "\${USER_PATH}"/Library && xattr -d com.apple.FinderInfo "\${USER_PATH}"/Library

##########################################################################################
# Fix permissions and restart apps and services, delete self
##########################################################################################

killall "Finder"
sleep 2
killall "SystemUIServer"
sleep 2
exit 0

##########################################################################################
# Second (and all future) Pass at Script
##########################################################################################

# This "else" attaches to the "First Pass at Script" section
else
	# have the computer set more stuff or run regular maintenance; for example
	# defaults write -g AppleShowAllExtensions -bool true
	exit 0
fi
XSCRIPT
chmod +x /Users/Shared/.company_user_setting.sh