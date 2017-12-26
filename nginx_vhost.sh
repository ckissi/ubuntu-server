#!/bin/bash

touch /etc/nginx/sites-available/test.elerion.com
echo '
server {
    listen 80 default_server;
    root /var/www/myapp/public;
    index index.html index.htm index.php;
    server_name _;
    location / {
        try_files $uri $uri/ /index.php$is_args$args;
    }
    location ~ \.php$ {
       include snippets/fastcgi-php.conf;
       fastcgi_pass unix:/var/run/php/php7.1-fpm.sock;
    }
}
' > /etc/nginx/sites-available/test.elerion.com
