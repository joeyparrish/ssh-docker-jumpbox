#!/bin/bash

# Create a user entry for the one and only jump user, but without a home
# directory or the ability to get an interactive shell.  This user will only be
# able to create tunnels.
/usr/sbin/useradd -d / -s /bin/false "$JUMP_USER"

# Put the relevant Docker environment variables into a file that the auth
# helper script can read easily.
> /etc/jump-settings
echo "JUMP_USER=\"$JUMP_USER\"" >> /etc/jump-settings
echo "JUMP_PUBLIC_KEY=\"$JUMP_PUBLIC_KEY\"" >> /etc/jump-settings

# Start the SSH daemon.
exec /usr/sbin/sshd -D -e
