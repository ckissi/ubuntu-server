#!/bin/bash
scriptPath=$PWD

#apt-get update
#apt-get -y install nginx 

#apt-get -y install php-fpm
#apt-get -y install php-mysql
#apt-get -y install php

# add php7 and nginx repos
sudo add-apt-repository -y ppa:nginx/development
sudo add-apt-repository -y ppa:ondrej/php
sudo apt-get update

# install basics
sudo apt-get install -y git tmux vim curl wget zip unzip htop

# Nginx
echo "Installing Nginx"
sudo apt-get install -y nginx

# PHP
echo "Installing PHP 7.1"
sudo apt-get install -y php7.1-fpm php7.1-cli php7.1-mcrypt php7.1-gd php7.1-mysql php7.1-pgsql php7.1-imap php-memcached php7.1-mbstring php7.1-xml php7.1-curl php7.1-bcmath php7.1-sqlite3 php7.1-xdebug

# Composer
echo "Installing Composer"
php -r "readfile('http://getcomposer.org/installer');" | sudo php -- --install-dir=/usr/bin/ --filename=composer
