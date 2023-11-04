#!/bin/bash

# Start code-server in the background
code-server --bind-addr 0.0.0.0:8080 &

# Wait for code-server to initialize and config file to be created
while [ ! -f /home/coder/.config/code-server/config.yaml ]
do
  sleep 1
done

# Output the password
echo "Your code-server password is:"
grep 'password:' /home/coder/.config/code-server/config.yaml | awk '{ print $2 }'

# Bring code-server back to the foreground
fg %1
