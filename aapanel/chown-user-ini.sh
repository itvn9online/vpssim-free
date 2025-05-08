#!/bin/bash

# file nay duoc luu lai code cua echbay.com
# /echbay.com/bash-script/chown-user-ini.sh

# chuyen ve root truoc khi chay lenh
cd ~

#
if [ -d /www/wwwroot ]; then

cd ~
# /usr/bin/chown -R www:www /www/wwwroot/
# /usr/bin/chown root:root /www/wwwroot/

cd /www/wwwroot
/usr/bin/find . -type f -name '*.user.ini' -exec /usr/bin/chmod 644 {} \;
/usr/bin/find . -type f -name '*.user.ini' -exec /usr/bin/chown root:root {} \;

#
cd ~

for db_dir in /www/wwwroot/*
do

if [ ! -d $db_dir ]; then
continue
fi

/usr/bin/chown -R www:www /www/wwwroot/$db_dir/

if [ -f $db_dir/.user.ini ]; then
/usr/bin/echo $db_dir/.user.ini
/usr/bin/chmod 644 $db_dir/.user.ini
/usr/bin/chown root:root $db_dir/.user.ini
fi

if [ -f $db_dir/public_html/.user.ini ]; then
/usr/bin/echo $db_dir/public_html/.user.ini
/usr/bin/chmod 644 $db_dir/public_html/.user.ini
/usr/bin/chown root:root $db_dir/public_html/.user.ini
fi

if [ -f $db_dir/public/.user.ini ]; then
/usr/bin/echo $db_dir/public/.user.ini
/usr/bin/chmod 644 $db_dir/public/.user.ini
/usr/bin/chown root:root $db_dir/public/.user.ini
fi

if [ -d $db_dir/tinyfilemanager ]; then
/usr/bin/echo $db_dir/tinyfilemanager
/usr/bin/rm -rf $db_dir/tinyfilemanager
fi

if [ -d $db_dir/public_html/tinyfilemanager ]; then
/usr/bin/echo $db_dir/public_html/tinyfilemanager
/usr/bin/rm -rf $db_dir/public_html/tinyfilemanager
fi

if [ -d $db_dir/public/tinyfilemanager ]; then
/usr/bin/echo $db_dir/public/tinyfilemanager
/usr/bin/rm -rf $db_dir/public/tinyfilemanager
fi

done

cd ~

fi
