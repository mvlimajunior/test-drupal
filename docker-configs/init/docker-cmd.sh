#!/bin/bash

IP=$(ip -4 route list match 0/0 | awk '{print $3}')
echo "Host ip is $IP"
echo "$IP   host.docker.internal" | tee -a /etc/hosts

# Start

service php8.0-fpm start
service nginx start

chown -R mysql.mysql /var/lib/mysql
usermod -d /var/lib/mysql/ mysql
service mysql start 


if  mysql -uroot -e "use ${MYSQL_DATABASE}"; then
    echo "Tabela já criada anteriormente"
else
    echo "Importar backup."
    
    mysql -uroot -e "update mysql.user set plugin = 'mysql_native_password' where User='root'; FLUSH PRIVILEGES;"
    mysql -uroot -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE}"

    echo "Banco de dados do docker-configs."
    mysql -uroot ${MYSQL_DATABASE} <  /var/www/html/db/dump-1.sql

    echo "Tabela criada utilizando o backup"
fi

#  Start projeto drupal
composer install &&

tail -f /var/log/nginx/error.log /var/log/nginx/access.log /var/log/php8.0-fpm.log