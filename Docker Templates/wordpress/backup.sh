#!/bin/bash

# A script to backup the database

# Load the .env file
if [ -f .env ]; then
    source .env
else
    echo ".env file not found!"
    exit 1
fi

docker exec $DB_CONTAINER mariadb-dump -u $DB_ROOT_USER --password=$DB_ROOT_PASS $PROJECT_NAME > $PROJECT_NAME".sql"
