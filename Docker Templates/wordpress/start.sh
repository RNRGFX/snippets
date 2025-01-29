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

# find existing instances in the host file and save the line numbers
matches_in_hosts="$(grep -n $SERVER_NAME /etc/hosts | cut -f1 -d:)"
host_entry="${ip_address} ${SERVER_NAME}"

# Password notice if not sudo
echo -e "\e[37m\nPlease enter your password if requested.\e[0m"   


if [ ! -z "$matches_in_hosts" ]
then
    echo -e "\e[33mHost $SERVER_NAME already exist.\n\e[0m"    
else
    echo -e "\e[34mAdding new hosts entry.\e[0m"
    echo "$host_entry" | sudo tee -a /etc/hosts > /dev/null
fi

# Check if database exists:

if [ "$(docker ps -q -f name=$DB_CONTAINER)" ]; then
    echo -e "\e[36mContainer $DB_CONTAINER is running\n\e[0m"
else
    echo -e "\e[31mContainer $DB_CONTAINER is not running\e[0m"
    echo -e "\e[35mStarting $DB_CONTAINER and adminer ...\e[0m"

    docker start $DB_CONTAINER
    docker start adminer

    # Wait for container to be running
    while ! docker ps -q -f name=$DB_CONTAINER >/dev/null 2>&1; do
        echo "Waiting for container $DB_CONTAINER to start..."
        sleep 2
    done

    echo -e "\e[36m$DB_CONTAINER is up and running!\n\e[0m"

fi

# Create database if not exist
docker exec "$DB_CONTAINER" mariadb -u"$DB_ROOT_USER" -p"$DB_ROOT_PASS" -e "CREATE DATABASE IF NOT EXISTS $PROJECT_NAME;"

# Start docker
echo -e "\e[32mStarting $PROJECT_NAME\e\n[0m"
docker compose up -d

# Get project folder
SCRIPT_DIR_NAME="$(basename "$(dirname "$(realpath "$0")")")"

# Nodejs script notice
echo -e "\e[32m\nExecuting $NODE_ACTION in /home/node/$SCRIPT_DIR_NAME$NODE_PATH\e[0m"

# Execute script in nodejs container - remember to update NODE_PATH and NODE_ACTION in .env
docker exec -w /home/node/$SCRIPT_DIR_NAME$NODE_PATH nodejs $NODE_ACTION
