#!/bin/bash
. /home/vpssim.conf

# tạo script in thông tin quản lý vps mỗi lần đăng nhập
#rm -rf /etc/motd
#yes | cp -rf /opt/echbay_vpssim/script/vpssim/motd /etc/motd
echo "" > /etc/motd

#
rm -rf /root/.info.sh
yes | cp -rf /opt/echbay_vpssim/script/vpssim/centos9/sh/.info.sh /root/.info.sh && chmod +x /root/.info.sh

# remove
sed -i -e "/\/root\/\.info\.sh/d" /root/.bash_profile
# add
echo "sh /root/.info.sh" >> /root/.bash_profile



#
rm -rf /bin/vpssim
yes | cp -rf /opt/echbay_vpssim/script/vpssim/centos9/vpssim /bin/vpssim && chmod +x /bin/vpssim



#
cd /etc/vpssim/
mkdir -p /etc/vpssim/menu ; chmod 755 /etc/vpssim/menu
yes | cp -rf /opt/echbay_vpssim/script/vpssim/menu/. /etc/vpssim/menu/
cd ~



#
mkdir -p /home/vpssim.demo/errorpage_html ; chmod 755 /home/vpssim.demo/errorpage_html
yes | cp -rf /opt/echbay_vpssim/script/vpssim/errorpage_html/. /home/vpssim.demo/errorpage_html/
mkdir -p /etc/vpssim/errorpage_html ; chmod 755 /etc/vpssim/errorpage_html
yes | cp -rf /opt/echbay_vpssim/script/vpssim/errorpage_html/. /etc/vpssim/errorpage_html/
