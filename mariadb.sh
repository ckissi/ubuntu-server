#!/bin/bash
# Settings for MariaDB

DB_ROOT=`</dev/urandom tr -dc '1234567890!@#$%qwertQWERTasdfgASDFGzxcvbZXCVB'| (head -c $1 > /dev/null 2>&1 || head -c 15)`

echo "Securing MariaDB... "
sleep 5
    sudo apt install -y expect
    sleep 15
echo "--> Set root password for Mysql sever "
expect -f - <<-EOF
  set timeout 10
  spawn mysql_secure_installation
  expect "Would you like to setup VALIDATE PASSWORD plugin?"
  send -- "N\r"
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
