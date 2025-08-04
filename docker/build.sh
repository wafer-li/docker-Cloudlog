#!/usr/bin/env sh

set -x -e

cd /usr/src
unzip master.zip

rm -rf /var/www/*
cp -a /usr/src/wavelog-*/* /var/www/
chown -R www-data: /var/www

echo "Done"
exit 0
