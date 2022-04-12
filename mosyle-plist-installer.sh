#!/bin/bash

# Write out preference files from Mosyle's Custom Commands function for local system/application usage.

# USE:
# 1. Set PLIST to be the path and name of the preference file you want to deploy.
# 2. Between the PREF markers put the XML settings you want
# 3. Update the version in THISPLISTVER and in the XML's <plist version="X.X">.
# 4. Create a Custom Command in Mosyle and use your edited script, assign it to endpoints, and save.
# Recommended: have the command run every day to keep your fleet up to date.

# The preference file you are pusing out
PLIST="/path/to/preference.plist"

# The current version of the plist
THISPLISTVER="1.1"

# This determines the version on the endpoint at the moment
CLIENTPLISTVER=$( cat "${PLIST}" | grep "plist version" | cut -d '"' -f2 )

# Compare the plist version on the endpoint versus the version being pushed out
# If version on client is older, it deletes that version
if [[ ${THISPLISTVER} = ${CLIENTPLISTVER} ]]; then
	exit 0
else
	rm -fr "${PLIST}"
    sleep 1
fi

# If no plist present (never there or deleted above) then install the current plist defined below
# Make sure to include <plist version="${THISPLISTVER}"> if copy/pasting your own
if [[ ! -e "${PLIST}" ]]; then
cat > "${PLIST}" <<PREF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="${THISPLISTVER}">
<dict>
	<key>awesomesauce</key>
	<true/>
	</dict>
</plist>
PREF
chmod 644 "${PLIST}"
chown root:wheel "${PLIST}"
fi
