#!/bin/bash

# Writes out the preferences file for the Zoom IT Installer

# USE:
# 1. Between the PREF put the XML settings you want, based on Zoom's documentation at
# https://support.zoom.us/hc/en-us/articles/115001799006-Mass-Deployment-with-Preconfigured-Settings-for-Mac
# 2. Edit the contents of the XML below. Update the version in THISPLISTVER and in the XML's
# <plist version="X.X">.
# 3. Create a Custom Command in Mosyle and use your edited script, assign to computers, and save. Recommended:
# have the command run every day to keep your fleet up to date.

# The current version of the plist you will push out to users
THISPLISTVER="1.1"
# This determines the version on the client at the moment
CLIENTPLISTVER=$( cat /Library/Preferences/us.zoom.config.plist | grep "plist version" | cut -d '"' -f2 )

# Compare the plist version on the client versus the version being pushed out
# If version on client is older, it deletes that version
if [[ ${THISPLISTVER} = ${CLIENTPLISTVER} ]]; then
	exit 0
else
	rm -fr /Library/Preferences/us.zoom.config.plist
    sleep 1
fi

# If no plist present (never there or deleted above) then install the current plist
if [[ ! -e /Library/Preferences/us.zoom.config.plist ]]; then
cat > /Library/Preferences/us.zoom.config.plist <<PREF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.1">
<dict>
	<key>nogoogle</key>
	<true/>
	<key>nofacebook</key>
	<true/>
	<key>ZDisableVideo</key>
	<true/>
	<key>ZAutoJoinVoip</key>
	<true/>
	<key>ZDualMonitorOn</key>
	<true/>
	<key>ZAutoSSOLogin</key>
	<true/>
	<key>ZSSOHost</key>
	<string>YourVanityURL.zoom.us</string>
	<key>ZAutoFullScreenWhenViewShare</key>
	<true/>
	<key>ZAutoFitWhenViewShare</key>
	<true/>
	<key>ZUse720PByDefault</key>
	<false/>
	<key>ZRemoteControlAllApp</key>
	<true/>
</dict>
</plist>
PREF
chmod 644 /Library/Preferences/us.zoom.config.plist
chown root:wheel /Library/Preferences/us.zoom.config.plist
fi