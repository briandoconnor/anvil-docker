#!/usr/bin/env bash

cp /galaxy/galaxy.yml.back /galaxy/config/galaxy.yml
cp /etc/nginx/default.back /etc/nginx/sites-available/default
cp /var/www/index.nginx-debian.html.back /var/www/html/index.nginx-debian.html
