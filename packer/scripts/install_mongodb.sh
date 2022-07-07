#!/bin/sh

rm /var/lib/apt/lists/lock
rm /var/cache/apt/archives/lock
rm /var/lib/dpkg/lock*

apt update
apt install -y mongodb-server
systemctl enable mongodb
systemctl start mongodb
