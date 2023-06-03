#!/bin/bash
. /home/vpssim.conf

#
echo "=========================================================================="
echo "Install phpMyAdmin..."
#sleep 2

#
cd ~

#
mkdir -p /home/vpssim.demo
mkdir -p /home/vpssim.demo/private_html
rm -rf /home/vpssim.demo/private_html/*
# tao thu muc cho phpmyadmin dung lam cache
mkdir -p /home/vpssim.demo/private_html/tmp
chmod 777 /home/vpssim.demo/private_html/tmp
cd /home/vpssim.demo/private_html/

#
wget --no-check-certificate https://files.phpmyadmin.net/phpMyAdmin/${phpmyadmin_version}/phpMyAdmin-${phpmyadmin_version}-all-languages.zip
unzip -q phpMyAdmin-*.zip
yes | cp -rf phpMyAdmin-*/* .
rm -rf phpMyAdmin-*
randomblow=`date |md5sum |cut -c '1-32'`;
sed -e "s|cfg\['blowfish_secret'\] = ''|cfg['blowfish_secret'] = '$randomblow'|" config.sample.inc.php > config.inc.php
