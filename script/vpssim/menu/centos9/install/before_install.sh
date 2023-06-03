#!/bin/bash
. /home/vpssim.conf

# install latest software
# https://tecadmin.net/how-to-install-php-on-centos-9/
# for centos 8
if [ "$current_os_version" == "8" ]; then
sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
sudo dnf install -y https://rpms.remirepo.net/enterprise/remi-release-8.rpm
else
# for centos 9
sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
sudo dnf install -y https://rpms.remirepo.net/enterprise/remi-release-9.rpm
fi
