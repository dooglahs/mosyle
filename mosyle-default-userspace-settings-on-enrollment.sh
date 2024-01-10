#!/bin/bash

# There are times you might want to set defaults for users when they enroll so they have
#	some default settings, but do not necessarily want to add a load of extra binaries
#	like the excellent `outset`.
# I worked around most of this by using this script to place a LaunchAgent in the application
#	layer (/Library) along with a script that it can call. This script is set to run only
#	on enrollment, so it will only run one time, and the elements are self-removing.

# USE:
# - Replace all instances of YOUR_COMPANY with your company name (without spaces).
# - Put all of your userspace code in the block designated.
#	- NOTE: some characters may need to be escaped; note USER_NAME variable for example.
# - Create a Custom Command in Mosyle and
#	- Add this script,
#	- Set the execution settings to run on enrollment,
#	- Assign to computers,
#	- And save.

##########################################################################################
# Create LaunchAgent to run script below on first login
##########################################################################################

cat > /Library/LaunchAgents/com.YOUR_COMPANY.user_settings.plist <<LAUNCHAGENTS
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>com.YOUR_COMPANY.user_settings</string>
	<key>Program</key>
	<string>/Library/Application Support/YOUR_COMPANY/user_settings.sh</string>
	<key>RunAtLoad</key>
	<true/>
</dict>
</plist>
LAUNCHAGENTS
chmod 644 /Library/LaunchAgents/com.YOUR_COMPANY.user_settings.plist
chown root:wheel /Library/LaunchAgents/com.YOUR_COMPANY.user_settings.plist

##########################################################################################
# Create working directory at /Library/Application Support
##########################################################################################

echo "Checking, and maybe creating, the /Library/Application Support/YOUR_COMPANY folder"

if [[ ! -d "/Library/Application Support/YOUR_COMPANY" ]]; then
	mkdir "/Library/Application Support/YOUR_COMPANY"
	chown root:wheel "/Library/Application Support/YOUR_COMPANY"
	chmod 755 "/Library/Application Support/YOUR_COMPANY"
fi

##########################################################################################
# Write the script to disk so the LaunchAgent can run it
##########################################################################################

cat > "/Library/Application Support/YOUR_COMPANY/user_settings.sh" <<XSCRIPT
#!/bin/bash

##########################################################################################
# Variables and stuff
##########################################################################################

USER_NAME=\$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ && ! /loginwindow/ { print \$3 }' )
USER_PATH="/Users/\${USER_NAME}"

##########################################################################################
# First Pass at Script; if already done then skip
##########################################################################################

if [[ -e "/Library/Application Support/YOUR_COMPANY/user_settings.txt" ]]; then
	FIRST_PASS_DONE="yes"
else
	touch "/Library/Application Support/YOUR_COMPANY/user_settings.txt"
	FIRST_PASS_DONE="no"
fi

if [[ \${FIRST_PASS_DONE} = no ]]; then

# Insure System Preferences is closed so we can write to some of these
osascript -e 'tell application "System Preferences" to quit'
killall cfprefsd

##########################################################################################
# User space settings, running as the local user
##########################################################################################
# PUT YOUR SETTINGS HERE.
##########################################################################################

# Set the Desktop Picture
osascript -e 'tell application "Finder" to set desktop picture to POSIX file "/Library/Desktop Pictures/Earth and Moon.jpg"'

# Finder: show all filename extensions
defaults write -g AppleShowAllExtensions -bool true

# Disable smart quotes and dashes
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false

##########################################################################################
# Restart apps and services
##########################################################################################

killall "Finder"
sleep 2
killall "SystemUIServer"
sleep 2

# Ensure this first pass doesn't run again
touch "/Library/Application Support/YOUR_COMPANY/user_settings.txt"

exit 0

##########################################################################################
# Second (and all future) Pass at Script, starting at ELSE
##########################################################################################

# This "else" attaches to the "First Pass at Script" section
else
	# Deletes this script and settings.
	rm -fr "/Library/Application Support/YOUR_COMPANY/user_settings.sh"
	# rm -fr "/Library/Application Support/YOUR_COMPANY/user_settings.txt"
	rm -fr "/Library/LaunchAgents/com.YOUR_COMPANY.user_settings.plist"
	exit 0
fi
XSCRIPT

chmod +x "/Library/Application Support/YOUR_COMPANY/user_setting.sh"
