# Prerequisits:
# - Allow inbound access to port 22 , 3389 and 80 (refer to repository NSG)

sudo apt update
sudo apt upgrade

# set priviledges to user
sudo-i
usermod -aG sudo xeac

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



