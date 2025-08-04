#!/bin/bash

source /start-preload.sh

if [ $(mysql -h ${DB_HOST} -u ${DB_USERNAME} -p${DB_PASSWORD} -s -e "select count(*) from information_schema.tables where table_schema='${DB_DATABASE}' and table_name='options';") -eq 0 ]
then
  echo "table options not found, installing db tables"
  mysql -h ${DB_HOST} -u ${DB_USERNAME} -p${DB_PASSWORD} ${DB_DATABASE} < /var/www/html/install/assets/install.sql
fi

# removing install dir
if [ -d "/var/www/html/install" ]
then
  echo "removing install dir, not needed anymore"
  rm -rf /var/www/html/install/
fi
