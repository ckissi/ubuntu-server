#!/bin/bash
echo "Please enter domain name: "
read domain
#echo "You entered: $domain"

mkdir /home/$domain
mkdir /home/$domain/logs
#mkdir /home/$domain/cgi-bin
mkdir /home/$domain/public

chown -R www-data:www-data /home/$domain

touch /etc/nginx/sites-available/$domain
echo '
server {
    listen 80;
    root /home/$domain/public;
    index index.html index.htm index.php;
    server_name $domain;
    location / {
        try_files $uri $uri/ /index.php$is_args$args;
    }
    location ~ \.php$ {
       include snippets/fastcgi-php.conf;
       fastcgi_pass unix:/var/run/php/php7.1-fpm.sock;
    }
}
' > /etc/nginx/sites-available/$domain

# enable vhost
nginx_ensite $domain

#reload nginx
service nginx reload
