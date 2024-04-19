# Custom attribute to find out if Homebrew is installed or not, and needs an update
# Returns a YES or a NO.
#	NO indicates Homebrew is either not installed or is installed but doesn't need an update
#	YES indicates Homebres is installed and also that it needs an update.
# I created a smart device group that lists all of the YES returns

# Run the script as the end user
sudo -u $(stat -f "%Su" /dev/console) /bin/sh <<'END'

# Is Homebrew installed and needing an update?
LOCAL_BREW_VERSION=$( /usr/local/bin/brew --version 2> /dev/null | sed -n 1p | awk '{print $2}' )
ONLINE_BREW_VERSION=$( curl --silent "https://api.github.com/repos/Homebrew/brew/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' )
if [[ ! -d /usr/local/Homebrew ]] || (( $(echo "${ONLINE_BREW_VERSION} ${LOCAL_BREW_VERSION}" | awk '{print ($1 == $2)}') )); then
	echo "NO"
else
	echo "YES"
fi
