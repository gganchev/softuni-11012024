#!/bin/bash

useradd myuser && groupadd mygroup && usermod -u 1001 myuser && groupmod -g 1001 mygroup && usermod -g 1001 myuser
sed -i 's/www-data/myuser/g' /etc/apache2/envvars

apachectl start

tail -f /var/log/apache2/mixed.log