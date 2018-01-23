#!/bin/bash
scriptPath=$PWD

# Make Swap (512MB) 
echo -n "Create Swap (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ;then
   echo "Creating Swap..."
   /bin/bash $scriptPath/makeswap.sh
   echo "Swap Done..."
else
    echo "Swap skipped"
fi

# install certbot
echo -n "Install Certbot (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ;then
  sudo apt-get update
  sudo apt-get install -y software-properties-common
  sudo add-apt-repository ppa:certbot/certbot
  sudo apt-get update
  sudo apt-get install -y python-certbot-nginx 
else
    echo "Certbot skipped"
fi

#remove apache2
sudo apt-get remove apache2*

# add php7 and nginx repos
sudo add-apt-repository -y ppa:nginx/development
sudo add-apt-repository -y ppa:ondrej/php
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C
sudo apt-get update

# install basics
sudo apt-get install -y git tmux vim curl wget zip unzip htop make

# install nginx_ensite
cd
git clone https://github.com/perusio/nginx_ensite.git
cd nginx_ensite
sudo make install

cd $scriptPath

# Nginx
echo "Installing Nginx"
sudo apt-get install -y nginx

# PHP
echo -n "Install PHP 7.1 (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ;then
    echo "Installing PHP 7.1"
    sudo apt-get install -y php7.1-fpm php7.1-cli php7.1-mcrypt php7.1-gd php7.1-mysql php7.1-pgsql php7.1-imap php-memcached php7.1-mbstring php7.1-xml php7.1-curl php7.1-bcmath php7.1-sqlite3 php7.1-xdebug
else
    echo "PHP 7.1 skipped"
fi

echo -n "Install PHP 5.6 (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ;then
    echo "Installing PHP 5.6"
    sudo apt-get install -y php5.6-fpm php5.6-cli php5.6-mcrypt php5.6-gd php5.6-mysql php5.6-xml php5.6-curl php5.6-mbstring
else
    echo "PHP 5.6 skipped"
fi

# Composer
echo -n "Install Composer (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ;then
    echo "Installing Composer"
    php -r "readfile('http://getcomposer.org/installer');" | sudo php -- --install-dir=/usr/bin/ --filename=composer
else
    echo "Composer skipped"
fi    
    

#MariaDB
echo "Installing MariaDB"
/bin/bash $scriptPath/mariadb.sh

# remove unneeded packages 
sudo apt -y autoremove
