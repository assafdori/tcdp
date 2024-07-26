#!/bin/bash
sudo yum update
sudo yum install -y docker
sudo systemctl start docker

sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sudo su

echo "version: '3'

services:
  mysql-server:
    image: mysql:latest
    container_name: mysql-server
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: store_info
      MYSQL_USER: user
      MYSQL_PASSWORD: userpassword
    ports:
      - "3306:3306"
    volumes:
      - mysql-data:/var/lib/mysql

volumes:
  mysql-data:

" > docker-compose.yml

docker-compose up -d
