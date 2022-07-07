#!/bin/sh

sudo apt update
sudo apt install -y mongodb-server
sudo systemctl enable mongodb
sudo systemctl start mongodb
