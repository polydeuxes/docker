#!/bin/bash

CONFIG_PATH="/home/app/.config/code-server/config.yaml"
BIND_ADDR="0.0.0.0:8080"

# Start code-server in the background with the specified bind address
code-server --bind-addr ${BIND_ADDR} &

# Initialize a counter to timeout after a certain amount of time
max_attempts=30
counter=0

echo "Waiting for code-server to initialize..."

while [ ! -f "$CONFIG_PATH" ]; do
  if [ $counter -gt $max_attempts ]; then
    echo "Timeout waiting for code-server to start. Config file not found."
    exit 1
  fi

  sleep 1
  ((counter++))
done
# Once the config file exists, wait a bit more to make sure it's been populated
sleep 5

# Now extract the password
PASSWORD=$(grep 'password:' "$CONFIG_PATH" | cut -d ' ' -f2)

if [ -z "$PASSWORD" ]; then
    echo "Failed to extract the password. Check the config file format and location."
    exit 1
else
    echo "Your code-server password is: $PASSWORD"
    echo "code-server is listening on: ${BIND_ADDR}"
fi


# Check if the rust analyzer extension is already installed
if [ ! -d "/home/app/.local/share/code-server/extensions/rust-analyzer" ]; then
    # Install the Rust Analyzer extension
    code-server --install-extension /home/app/rust-analyzer-linux-x64.vsix
fi

# Keep the script running to keep the container alive
wait $!
