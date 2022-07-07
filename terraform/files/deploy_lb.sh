#!/bin/bash
set -e
sudo rm /var/lib/apt/lists/lock
sudo rm /var/cache/apt/archives/lock
sudo rm /var/lib/dpkg/lock*

sudo apt-get install -y nginx
sudo mv /tmp/puma.conf /etc/nginx/conf.d/puma.conf
sudo mkdir /etc/nginx/includes
sudo mv /tmp/puma-servers /etc/nginx/includes/puma-servers

sudo systemctl restart nginx
sudo systemctl enable nginx
