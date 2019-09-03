#!/bin/bash -xe

sudo apt-get update -y 

# install docker
sudo curl https://releases.rancher.com/install-docker/17.03.sh | sh
sudo usermod -a -G docker admin

# Run wordpress container that connects with RDS cluster.
sudo docker run --name test-wordpress -e WORDPRESS_DB_HOST="${rds_endpoint}" -e WORDPRESS_DB_USER=rdsuser -e WORDPRESS_DB_PASSWORD=testrds -d wordpress
