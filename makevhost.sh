#!/bin/bash
echo "Please enter domain name: "
read domain
#echo "You entered: $domain"

#remove old config
rm -f /etc/nginx/sites-available/$domain

mkdir /home/$domain
mkdir /home/$domain/logs
#mkdir /home/$domain/cgi-bin
mkdir /home/$domain/public

chown -R www-data:www-data /home/$domain

touch /home/$domain/public/index.html
echo "$domain" > /home/$domain/public/index.html

touch /etc/nginx/sites-available/$domain
#echo "
cat > /etc/nginx/sites-available/$domain <<EOF
# Redirect non-www to www
server {
        server_name $domain;
        return 301 \$scheme://www.$domain\$request_uri;
}

server {
    listen 80;
    root /home/$domain/public;
    index index.html index.htm index.php;
    server_name www.$domain;

    # Enter SSL certificates here
    #ssl_certificate /etc/nginx/ssl/myweb.com/276900/server.crt;
    #ssl_certificate_key /etc/nginx/ssl/myweb.com/276900/server.key;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Content-Type-Options "nosniff";

    location / {
        try_files \$uri \$uri/ /index.php\$is_args\$args;
    }
    location ~ \.php$ {
       include snippets/fastcgi-php.conf;
       fastcgi_pass unix:/run/php/php7.1-fpm.sock;
    }
}
EOF
#" > /etc/nginx/sites-available/$domain

# enable vhost
nginx_ensite $domain

#reload nginx
sudo nginx -t && sudo service nginx reload
