# Run backup of SQL:
docker exec sweethome-mariadb-1 mariadb-dump -u root --password=[xxx] [db_name] > wordpress.sql

# NODE:
## Update version and create .zip
docker exec sweethome-nodejs-1 npm run build:prod