#!/bin/bash

# Allow user to write to wp-content
sudo chmod 777 -R wp-content

# Load the .env file
if [ -f .env ]; then
    source .env
else
    echo ".env file not found!"
    exit 1
fi

# insert/update hosts entry
ip_address="127.0.0.1"
host_name=$SERVER_NAME

# find existing instances in the host file and save the line numbers
matches_in_hosts="$(grep -n $host_name /etc/hosts | cut -f1 -d:)"
host_entry="${ip_address} ${host_name}"

# Password notice if not sudo
echo -e "\e[33mPlease enter your password if requested.\e[0m"   


if [ ! -z "$matches_in_hosts" ]
then
    echo -e "\e[33mHost already exist.\e[0m"    
else
    echo -e "\e[34mAdding new hosts entry.\e[0m"
    echo "$host_entry" | sudo tee -a /etc/hosts > /dev/null
fi

# Get project folder
SCRIPT_DIR_NAME="$(basename "$(dirname "$(realpath "$0")")")"

# Start docker
docker compose up -d

# Nodejs script notice
echo -e "\e[32mExecuting $NODE_ACTION in /home/node/$SCRIPT_DIR_NAME$NODE_PATH\e[0m"

# Execute script in nodejs container - remember to update NODE_PATH and NODE_ACTION in .env
docker exec -w /home/node/$SCRIPT_DIR_NAME$NODE_PATH nodejs $NODE_ACTION
