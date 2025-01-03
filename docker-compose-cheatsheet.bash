# Stop all docker containers:
docker stop $(docker ps -a -q)

# Enable editing wp-content
sudo chmod 777 -R wp-content
