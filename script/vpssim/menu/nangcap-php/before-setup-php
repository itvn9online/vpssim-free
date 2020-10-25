#!/bin/bash

mkdir -p /root/updown
yes | cp -rf /etc/php-fpm.conf /root/updown/
if [ -f /etc/php.d/opcache.bak ]; then
yes | cp -rf /etc/php.d/opcache.bak /root/updown/
fi
if [ -f /etc/php.d/opcache.ini ]; then
yes | cp -rf /etc/php.d/opcache.ini /root/updown/
fi
yes | cp -rf /etc/php.ini /root/updown/
yes | cp -rf /etc/php-fpm.d/www.conf /root/updown


# kiem tra cac module neu co thi cho vao config
imagickstatus=0
if [ -f /etc/php.d/imagick.ini ]; then
imagickstatus=1
rm -rf /etc/php.d/imagick.ini 
echo "Uninstall imagick..."
pecl uninstall imagick > /dev/null 2>&1
fi

suhosin=0
if [ -f /etc/php.d/*suhosin*.ini ]; then
suhosin=1
fi

ioncubestatus=0
if [ -f /etc/php.d/ioncube.ini ]; then
ioncubestatus=1
rm -rf /etc/php.d/*.ioncube.*
rm -rf /etc/php.d/ioncube.*
rm -rf /usr/local/ioncube
fi

echo "imagickstatus="$imagickstatus >> /tmp/change_php_config
echo "suhosin="$suhosin >> /tmp/change_php_config
echo "ioncubestatus="$ioncubestatus >> /tmp/change_php_config



echo "Uninstall php..."
yum -y remove php\* > /dev/null 2>&1
