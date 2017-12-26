#!/bin/bash

export LC_ALL="en_US.UTF-8"

# Settings for MariaDB
DB_ROOT=`</dev/urandom tr -dc '1234567890qwertQWERTasdfgASDFGzxcvbZXCVB'| (head -c $1 > /dev/null 2>&1 || head -c 15)`
DB_NAME=`</dev/urandom tr -dc a-z0-9| (head -c $1 > /dev/null 2>&1 || head -c 8)`
DB_USER=`</dev/urandom tr -dc a-z0-9| (head -c $1 > /dev/null 2>&1 || head -c 8)`
DB_PASSWORD=`</dev/urandom tr -dc A-Za-z0-9| (head -c $1 > /dev/null 2>&1 || head -c 10)`
echo ""
CONFIG_DIR=$PWD
#Setup settings.txt for MySQL
    sed -i "s/DB_ROOT/$DB_ROOT/g" $CONFIG_DIR/settings.txt
    sed -i "s/DB_NAME/$DB_NAME/g" $CONFIG_DIR/settings.txt
    sed -i "s/DB_USER/$DB_USER/g" $CONFIG_DIR/settings.txt
    sed -i "s/DB_PASSWORD/$DB_PASSWORD/g" $CONFIG_DIR/settings.txt
    sed -i "s/DB_HOSTNAME/$DB_HOSTNAME/g" $CONFIG_DIR/settings.txt
    sed -i "s/DB_PORT/$DB_PORT/g" $CONFIG_DIR/settings.txt

sudo apt-get update
sudo apt-get install -y mariadb-server mariadb-client

echo "Securing MariaDB... "
sleep 5
    sudo apt install -y expect
    sleep 15
echo "--> Set root password for Mysql sever "
expect -f - <<-EOF
  set timeout 1
  spawn mysql_secure_installation
  expect "Enter current password for root (enter for none):"
  send -- "\r"
  expect "Change the root password?"
  send -- "Y\r"
  expect "New password:"
  send -- "$DB_ROOT\r"
  expect "Re-enter new password:"
  send -- "$DB_ROOT\r"
  expect "Remove anonymous users?"
  send -- "y\r"
  expect "Disallow root login remotely?"
  send -- "y\r"
  expect "Remove test database and access to it?"
  send -- "y\r"
  expect "Reload privilege tables now?"
  send -- "y\r"
  expect eof
EOF

mysql --user="root" --password="$DB_ROOT" <<EOF
use mysql;
update user set plugin='mysql_native_password' where user='root';
flush privileges;
EOF

#mysql -u root -p$DB_ROOT;
#use mysql;
#update user set plugin='mysql_native_password' where user='root';
#flush privileges; 
#quit;
