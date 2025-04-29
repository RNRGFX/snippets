#!/bin/bash
# Install OpenSSL
sudo apt update
sudo apt install openssl

# create folder and set permissions
sudo mkdir certs
sudo chmod 777 certs

# enter folder
cd certs

# Create certificate
openssl req -x509 -nodes -days 100000 -newkey rsa:2048 -keyout cert.key -out cert.crt

# install ca-certificates
sudo apt-get install -y ca-certificates

# copy the certificate
sudo cp cert.crt /usr/local/share/ca-certificates

# add certificate to local user
sudo update-ca-certificates

