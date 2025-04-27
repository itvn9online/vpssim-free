#!/bin/bash

# file nay duoc luu lai code cua echbay.com
# /echbay.com/bash-script/chown-user-ini.sh

# chuyen ve root truoc khi chay lenh
cd ~

#
if [ -d /www/wwwroot ]; then

cd ~
/usr/bin/chown -R www:www /www/wwwroot/
/usr/bin/chown root:root /www/wwwroot/

cd /www/wwwroot
/usr/bin/find . -type f -name '*.user.ini' -exec /usr/bin/chmod 644 {} \;
/usr/bin/find . -type f -name '*.user.ini' -exec /usr/bin/chown root:root {} \;

fi
