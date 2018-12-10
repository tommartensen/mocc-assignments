#!/bin/bash

# based on https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-18-04

# install nginx
apt-get update && apt-get install -y ufw nginx

# enable firewall and allow http
ufw enable && ufw allow 'Nginx HTTP'

# start service
systemctl restart nginx

# create file
dd if=/dev/urandom of=/var/www/html/file bs=10M count=51
