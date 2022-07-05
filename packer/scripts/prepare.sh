#!/bin/sh

rm /var/lib/apt/lists/lock
rm /var/cache/apt/archives/lock
rm /var/lib/dpkg/lock*

apt update
apt install -y mongodb-server ruby-full ruby-bundler build-essential git

systemctl enable mongodb
systemctl start mongodb

mkdir /opt/app
cd /opt/app

git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install

echo '[Unit]
Description=reddit app
After=network.target mongodb.service

[Service]
Type=notify
WatchdogSec=10
WorkingDirectory=/opt/app/reddit
ExecStart=/usr/local/bin/puma -C /opt/app/reddit/config/deploy/production.rb
Restart=always

[Install]
WantedBy=multi-user.target' >> /etc/systemd/system/reddit.service

systemctl daemon-reload
systemctl enable reddit.service
