# Inspect Subnet and Gateways:
docker network inspect $(docker network ls -q) | grep "Subnet\|Gateway"

# Create network with an IP-address NOT in use by above results:
docker network create --driver=bridge --subnet=172.20.0.0/16 --gateway=172.20.0.1 rnrgfx
