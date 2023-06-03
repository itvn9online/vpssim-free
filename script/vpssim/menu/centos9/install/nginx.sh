#!/bin/bash
. /home/vpssim.conf

#
echo "=========================================================================="
echo "Install Nginx"

# thiet lap phien ban nginx cho centos 8 do ban nginx tren nay kha cu
if [ "$current_os_version" == "8" ]; then
sudo dnf module reset nginx -y
sudo dnf module list nginx -y
sudo dnf module enable nginx:1.22 -y
fi

#sleep 2
yum install nginx -y
#nginx -v
#nginx -V
# Bắt đầu khởi chạy web server
systemctl start nginx

# Tự động khởi chạy web server mỗi khi chúng ta reboot Cloud Instance
systemctl enable nginx

# Kiểm tra trạng thái web server
#systemctl status nginx

# Cho phép các kết nối http
firewall-cmd --permanent --zone=public --add-service=http 

# Cho phép các kết nối https
firewall-cmd --permanent --zone=public --add-service=https

# Khởi chạy lại firewall service
firewall-cmd --reload

#
chown nginx:nginx /usr/share/nginx/html -R
