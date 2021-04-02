#!/bin/bash

# Mosyle doesn't run Python from the Custom Commands options; currently just bash and zsh.
# To run Python, or other scripting environments use general format:
#	1. create file on local drive with cat
#	2. modify the permissions on the file so it will run
#	3. run the local script
#	4. delete the local script
# Ensure the scripting environment exists on the endpoint.

# Make a file on the endpoint that is the script.
cat << 'EOF' > "/tmp/script.py"
#!/usr/bin/python
*Script Contents*
EOF
# Fix permissions for the script.
chmod +x /tmp/script.py
# Run the script.
python /tmp/script.py
# Delete the script so it doesn't linger.
rm -rf /tmp/script.py