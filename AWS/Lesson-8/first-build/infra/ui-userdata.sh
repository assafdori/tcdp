#!/bin/bash
sudo yum update
sudo yum install -y docker
sudo systemctl start docker

sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sudo su

echo "version: '3'
services:
  adminer:
    image: adminer
    ports:
      - "8080:8080"
" > docker-compose.yml

docker-compose up -d

docker run -d -p 3306:3306 --name mysql --env MYSQL_ROOT_PASSWORD=123456 mysql # for mysql cli

