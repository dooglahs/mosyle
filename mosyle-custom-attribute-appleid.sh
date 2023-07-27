# Custom attribute to get currently used AppleID; if none put none.
# Run script as end user
sudo -u $(stat -f "%Su" /dev/console) /bin/sh <<'END'
# Pull AppleID email address if present
AID=$( defaults read MobileMeAccounts Accounts 2>/dev/null | grep AccountID | awk -F" = " '{print $2}' | sed 's/"//g' | sed 's/;//g' )
if [[ ${AID} =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$ ]]; then
	echo "${AID}"
else
	echo "none"
fi
