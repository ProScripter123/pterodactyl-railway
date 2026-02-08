#!/bin/bash

# Start MySQL
mysqld_safe --datadir=/var/lib/mysql &
sleep 10

# Buat DB default
mysql -e "CREATE DATABASE IF NOT EXISTS panel;"
mysql -e "CREATE USER IF NOT EXISTS 'ptero'@'localhost' IDENTIFIED BY 'password';"
mysql -e "GRANT ALL PRIVILEGES ON panel.* TO 'ptero'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

# Jalankan migrasi dan seeding
cd /var/www
php artisan migrate --force
php artisan db:seed --force

# Jalankan built-in PHP server
php artisan serve --host=0.0.0.0 --port=8080
