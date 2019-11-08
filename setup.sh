# Prerequisits:
# - Allow inbound access to port 22 , 3389 and 80 (refer to repository NSG)

sudo apt update
sudo apt upgrade

# set priviledges to user
#sudo-i
sudo usermod -aG sudo $(whoami)

# Setting Up a Basic Firewall
sudo ufw app list

# if OpenSSH not allowed run following:
sudo ufw allow OpenSSH
sudo ufw allow SSH
sudo ufw enable

# Installing the Nginx Web Server
sudo apt install nginx
sudo ufw allow 'Nginx HTTP'
sudo ufw status
# at least OpenSSH, SSH and Nginx HTTP should be active

# Installing MySQL to Manage Site Data
sudo apt install mysql-server
sudo mysql_secure_installation

# auth_socket plugin to access MySQL and root  - ask Marti

# Installing PHP and Configuring Nginx to Use the PHP Processor

sudo apt install php-fpm php-mysql
sudo nano /etc/nginx/sites-available/naposao.rs

server {
        listen 80;
        root /var/www/html;
        index index.php index.html index.htm index.nginx-debian.html;
        server_name 40.85.97.11;

        location / {
                try_files $uri $uri/ =404;
        }

        location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
        }

        location ~ /\.ht {
                deny all;
        }
}

sudo ln -s /etc/nginx/sites-available/naposao.rs /etc/nginx/sites-enabled/
sudo unlink /etc/nginx/sites-enabled/default
#check the config
sudo nginx -t
sudo systemctl reload nginx

# Install and Use Composer
sudo apt update
sudo apt install curl php-cli php-mbstring git unzip
cd ~
curl -sS https://getcomposer.org/installer -o composer-setup.php
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
composer update

# Installing Required PHP modules
sudo apt install php-mbstring php-xml php-bcmath

sudo mysql
CREATE DATABASE naposao_test;
GRANT ALL ON *.* to 'xeac'@'%' IDENTIFIED BY 'PassWord12!@' WITH GRANT OPTION;
flush privileges;
exit

# Creating a DB and users is challanging. Try to migrate the existing naposao DB. Map windows drive to Ubuntu - check with Martin 

cd ~
composer create-project --prefer-dist laravel/laravel naposao_test
cd naposao_test
php artisan

# ConfiguringLaravel
nano .env
sudo mv ~/naposao_test /var/www/naposao_test
sudo chown -R www-data.www-data /var/www/naposao_test/storage
sudo chown -R www-data.www-data /var/www/naposao_test/bootstrap/cache
sudo nano /etc/nginx/sites-available/naposao_test

server {
    listen 80;
    server_name 40.85.97.11;
    root /var/www/naposao_test/public;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Content-Type-Options "nosniff";

    index index.html index.htm index.php;

    charset utf-8;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    error_page 404 /index.php;

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.(?!well-known).* {
        deny all;
    }
}

# I had to remove duplicated IP from a second sites-enabled config

sudo ln -s /etc/nginx/sites-available/naposao_test /etc/nginx/sites-enabled/
sudo systemctl reload nginx

# Open MySQL port in/out 3306
 sudo netstat -ntlp | grep LISTEN
 sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
# replace bind-address = 0.0.0.0
 sudo service mysql restart
 sudo service mysql status

# To be tested because of the sequence. 
 git init
 git pull
 git pull https://github.com/xeac/naposao.git test
 git remote add https://github.com/xeac/naposao.git
 git remote add origin https://github.com/xeac/naposao.git
 git fetch
 git pull origin test
 bash gitUpdate.sh
        #!/bin/bash
        cd /var/www/naposao
        git pull origin master



 sudo apt-get install php7.2-gd
 sudo reboot
 sudo apt-get install php-curl
 sudo apt-get update
 sudo service apache2 restart
 composer require illuminate/html


