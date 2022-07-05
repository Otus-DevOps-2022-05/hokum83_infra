#!/bin/sh

sudo apt update
sudo apt install -y mongodb-server
sudo systemctl enable mongodb
sudo systemctl start mongodb

sudo apt install -y ruby-full ruby-bundler build-essential

mkdir /run/app
cd /run/app
sudo apt install -y git
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
puma -d
