#!/bin/bash

# file nay duoc luu lai code cua echbay.com
# /echbay.com/bash-script/create-user-ini-if-not-exist.sh

# chuyen ve root truoc khi chay lenh
cd ~


# ko cho chay lien tuc neu tien trinh truoc day chua xong
isRunningProcess="/tmp/cronjob-10m.lock"
if [ -f $isRunningProcess ]; then

echo "Process is running, exit"
exit 1

fi

# neu ko co file lock thi tao moi
# /usr/bin/touch $isRunningProcess
/usr/bin/echo $(date) > $isRunningProcess


# Memcached Daemon
btpython /www/server/panel/script/restart_services.py memcached

# Redis Daemon
btpython /www/server/panel/script/restart_services.py redis

# Nginx Daemon
btpython /www/server/panel/script/restart_services.py nginx

# Mysql Daemon
btpython /www/server/panel/script/restart_services.py mysql


# lay danh sach file log trong thu muc /www/wwwlogs
for tep in /www/wwwlogs/*.log
do

#
# echo $tep
# lay phan mo rong file log
ext=$(basename $tep)
# echo $ext

# neu phan mo rong co chua .error.log thi bo qua
if [[ $ext == *".error.log" ]]; then
echo $tep
continue
fi

# neu phan mo rong co chua .log thi tinh dung luong
if [[ $ext == *".log" ]]; then
# lay dung luong file log
# echo $tep
dungLuong=$(du -sh $tep)
echo $dungLuong

# neu dung luong > 10M thi xoa
if [[ $dungLuong == *"M"* ]]; then
# lay phan tu dung luong
dungLuong=$(echo $dungLuong | cut -d "M" -f 1)
echo $dungLuong
# lam tron dung luong
dungLuong=$(echo $dungLuong | cut -d "." -f 1)
echo $dungLuong

# neu dung luong > 10 thi xoa
if [ $dungLuong -gt 10 ]; then

# gui post request den server bao gom ten file va dung luong
curl -k -X POST -d "f=$tep&dl=$dungLuong" https://echbay.com/?act=daily_domain_access

# xoa file log
echo "Xoa file log "$tep
/usr/bin/rm -rf $tep

# thoat khoi vong lap, moi lan chi xoa 1 file log
break

fi

fi

# tiep tuc
continue

fi

# in ra ten file
echo $tep

done



# lay ngay thang nam hien tai
curDate=$(/usr/bin/date +%Y-%m-%d)
curDate="/tmp/cronjob-10m-"$curDate".log"
echo "curDate: "$curDate

# lay ngay thang nam hom qua
# yesterdayDate=$(/usr/bin/date -d "1 days ago" +%Y-%m-%d)
# yesterdayDate="/tmp/cronjob-10m-"$yesterdayDate".log"
# echo "yesterdayDate: "$yesterdayDate

# nếu ko có file log thì tạo mới
if [ ! -f $curDate ]; then

# xoa file log cu neu co
/usr/bin/rm -rf /tmp/cronjob-10m-*.log

# tạo file log moi, moi ngay chi chay 1 lan
/usr/bin/echo "# create file" > $curDate
/usr/bin/echo $(date) >> $curDate

# Domain SSL Renew Let's Encrypt Certificate
/www/server/panel/pyenv/bin/python3 -u /www/server/panel/class/acme_v2.py --renew_v3=1

# Renew Let's Encrypt Certificate
# /www/server/panel/pyenv/bin/python3 -u /www/server/panel/class/acme_v2.py --renew_v3=1

else

echo "File daily-log da ton tai, khong tao moi"

fi


# khai bao tham so cho phep update wordpress qua cronjob
okUpdateWordpress=1

# neu okUpdateWordpress = 1 thi moi kich hoat update wordpress
if [ $okUpdateWordpress -eq 1 ]; then

# lay ngay trong tuan
toDay=$(/usr/bin/date +%u)
echo "toDay: "$toDay

# neu toDay = 1 (thu 2)
if [ $toDay -eq 1 ]; then

# lay tuan hien tai trong nam
curWeek=$(/usr/bin/date +%Y-%V)
curWeek="/tmp/cronjob-1week-"$curWeek".log"
echo "curWeek: "$curWeek

# neu ko co file log thi tao moi
if [ ! -f $curWeek ]; then

# xoa file log cu neu co
/usr/bin/rm -rf /tmp/cronjob-1week-*.log

# tạo file log moi, moi tuan chi chay 1 lan
/usr/bin/echo "# create file" > $curWeek
/usr/bin/echo $(date) >> $curWeek

# Find and update plugin and Wordpress core for Wordpress website
# bash <( curl -k https://raw.echbay.com/itvn9online/vpssim-free/master/script/vpssim/menu/tienich/update-wordpress-for-all-site )
bash <( curl -k https://raw.echbay.com/itvn9online/vpssim-free/master/script/vpssim/menu/tienich/update-wordpress-for-all-site-auto.sh )


# Find and Scan malware for Wordpress website
# bash <( curl -k https://raw.echbay.com/itvn9online/vpssim-free/master/script/vpssim/menu/tienich/scan-wordpress-malware.sh )
# bash <( curl -k https://raw.echbay.com/itvn9online/vpssim-free/master/script/vpssim/menu/tienich/scan-wordpress-malware-auto.sh )

# tao file .user.ini neu chua ton tai
bash <( curl -k https://raw.echbay.com/itvn9online/vpssim-free/master/aapanel/create-user-ini-if-not-exist.sh )

# phan quyen file .user.ini
bash <( curl -k https://raw.echbay.com/itvn9online/vpssim-free/master/aapanel/chown-user-ini.sh )

else

echo "File weekly-log da ton tai, khong tao moi"

fi

else

echo "Lenh nay chi chay vao thu 2 hang tuan"

fi

else

echo "Lenh nay chi chay neu okUpdateWordpress=1"

fi


# xoa file lock
/usr/bin/rm -rf $isRunningProcess
