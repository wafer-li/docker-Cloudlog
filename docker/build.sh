#!/usr/bin/env bash

set -x -e

cd /usr/src
unzip master.zip

rm -rf /var/www/html/*
cp -a /usr/src/wavelog-*/* /var/www/html/
chown -R www-data: /var/www

echo "Done"
exit 0
