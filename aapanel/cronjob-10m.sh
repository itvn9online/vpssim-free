#!/bin/bash

# file nay duoc luu lai code cua echbay.com
# /echbay.com/bash-script/cronjob-10m.sh

# chuyen ve root truoc khi chay lenh
cd ~


# ko cho chay lien tuc neu tien trinh truoc day chua xong
isRunningProcess="/tmp/cronjob-10m.lock"
if [ -f $isRunningProcess ]; then

/usr/bin/echo "Process is running, exit"
exit 1

fi

# neu ko co file lock thi tao moi
# /usr/bin/touch $isRunningProcess
/usr/bin/echo $(date) > $isRunningProcess

# 
/usr/bin/rm -rf /tmp/cronjob-10m-*.log
/usr/bin/rm -rf /tmp/cronjob-1hrs-*.log

# Memcached Daemon
btpython /www/server/panel/script/restart_services.py memcached

# Redis Daemon
btpython /www/server/panel/script/restart_services.py redis

# Nginx Daemon
btpython /www/server/panel/script/restart_services.py nginx

# Mysql Daemon
btpython /www/server/panel/script/restart_services.py mysql



# tao lai file access log neu chua co
create_file_access_log(){

cd ~
okChmodAccessLog=0

for db_dir in /www/wwwroot/*
do

if [ -d $db_dir ]; then
ext=$(/usr/bin/basename $db_dir)
# /usr/bin/echo $ext
if [ -f "/www/wwwlogs/"$ext".error.log" ] && [ ! -f "/www/wwwlogs/"$ext".log" ]; then
# /usr/bin/echo "/www/wwwlogs/"$ext".error.log"
/usr/bin/echo "/www/wwwlogs/"$ext".log"
/usr/bin/echo $(/usr/bin/date) > "/www/wwwlogs/"$ext".log"
okChmodAccessLog=0
fi

fi

done

if [ $okChmodAccessLog -eq 1 ]; then
cd /www/wwwlogs
/usr/bin/find . -type f -name '*.log' -exec /usr/bin/chmod 644 {} \;
/usr/bin/find . -type f -name '*.log' -exec /usr/bin/chown www:www {} \;
cd ~
fi

}
# create_file_access_log



# count access log
cd ~

# lay ngay thang nam hien tai
curHour=$(/usr/bin/date +%Y-%m-%d)
curHour="/tmp/cronjob-1day-"$curHour".log"
/usr/bin/echo "curHour: "$curHour

# nếu ko có file log thì tạo mới
if [ ! -f $curHour ]; then

# xoa file log cu neu co
/usr/bin/rm -rf /tmp/cronjob-1day-*.log

# tạo file log moi, moi ngay chi chay 1 lan
/usr/bin/echo "# create file" > $curHour
/usr/bin/echo $(/usr/bin/date) >> $curHour

# lay danh sach file log trong thu muc /www/wwwlogs
for tep in /www/wwwlogs/*.log
do

#
# /usr/bin/echo $tep
# lay phan mo rong file log
ext=$(basename $tep)
# /usr/bin/echo $ext

# 
/usr/bin/echo $tep
/usr/bin/echo $tep >> $curHour

# neu phan mo rong co chua .error.log thi bo qua
if [[ $ext == *".error.log" ]]; then
continue
fi

# neu phan mo rong co chua .log thi tinh dung luong
if [[ $ext == *".log" ]]; then
# lay dung luong file log
# /usr/bin/echo $tep
dungLuong=$(du -sh $tep)
/usr/bin/echo $dungLuong
/usr/bin/echo $dungLuong >> $curHour

# neu dung luong > 10M thi xoa
if [[ $dungLuong == *"M"* ]]; then
# lay phan tu dung luong
dungLuong=$(/usr/bin/echo $dungLuong | cut -d "M" -f 1)
/usr/bin/echo $dungLuong
# lam tron dung luong
dungLuong=$(/usr/bin/echo $dungLuong | cut -d "." -f 1)
/usr/bin/echo $dungLuong
/usr/bin/echo $dungLuong >> $curHour

# neu dung luong > 10 thi xoa
if [ $dungLuong -gt 10 ]; then

# gui post request den server bao gom ten file va dung luong
/usr/bin/curl -k -X POST -d "f=$tep&dl=$dungLuong" https://api.echbay.com/?act=daily_domain_access

# xoa file log
/usr/bin/echo "Xoa file log "$tep
# /usr/bin/rm -rf $tep
/usr/bin/echo $(date) > $tep

# xoa file log nay de vong lap sau tiep tuc luon
/usr/bin/rm -rf /tmp/cronjob-1day-*.log

# thoat khoi vong lap, moi lan chi xoa 1 file log
break

fi

fi

# tiep tuc
continue

fi

# in ra ten file
# /usr/bin/echo $tep

done

else

/usr/bin/echo "File hour-log da ton tai, khong tao moi"

fi

# END count access log



# lay ngay thang nam hien tai
curDate=$(/usr/bin/date +%Y-%m-%d)
curDate="/tmp/cronjob-daily-"$curDate".log"
/usr/bin/echo "curDate: "$curDate

# lay ngay thang nam hom qua
# yesterdayDate=$(/usr/bin/date -d "1 days ago" +%Y-%m-%d)
# yesterdayDate="/tmp/cronjob-daily-"$yesterdayDate".log"
# /usr/bin/echo "yesterdayDate: "$yesterdayDate

# nếu ko có file log thì tạo mới
if [ ! -f $curDate ]; then

# xoa file log cu neu co
/usr/bin/rm -rf /tmp/cronjob-daily-*.log

# tạo file log moi, moi ngay chi chay 1 lan
/usr/bin/echo "# create file" > $curDate
/usr/bin/echo $(date) >> $curDate

# Domain SSL Renew Let's Encrypt Certificate
# /www/server/panel/pyenv/bin/python3 -u /www/server/panel/class/acme_v2.py --renew_v3=1

# Renew Let's Encrypt Certificate
# /www/server/panel/pyenv/bin/python3 -u /www/server/panel/class/acme_v2.py --renew_v2=1

else

/usr/bin/echo "File daily-log da ton tai, khong tao moi"

fi


# khai bao tham so cho phep update wordpress qua cronjob
okUpdateWordpress=1

# neu okUpdateWordpress = 1 thi moi kich hoat update wordpress
if [ $okUpdateWordpress -eq 1 ]; then

# lay ngay trong tuan
toDay=$(/usr/bin/date +%u)
/usr/bin/echo "toDay: "$toDay

# neu toDay = 1 (thu 2)
if [ $toDay -eq 1 ]; then

# lay tuan hien tai trong nam
curWeek=$(/usr/bin/date +%Y-%V)
curWeek="/tmp/cronjob-1week-"$curWeek".log"
/usr/bin/echo "curWeek: "$curWeek

# neu ko co file log thi tao moi
if [ ! -f $curWeek ]; then

# xoa file log cu neu co
/usr/bin/rm -rf /tmp/cronjob-1week-*.log

# tạo file log moi, moi tuan chi chay 1 lan
/usr/bin/echo "# create file" > $curWeek
/usr/bin/echo $(date) >> $curWeek

# Find and update plugin and Wordpress core for Wordpress website
# /usr/bin/bash <( curl -k https://raw.echbay.com/itvn9online/vpssim-free/master/script/vpssim/menu/tienich/update-wordpress-for-all-site )
/usr/bin/bash <( curl -k https://raw.echbay.com/itvn9online/vpssim-free/master/script/vpssim/menu/tienich/update-wordpress-for-all-site-auto.sh )


# Find and Scan malware for Wordpress website
echo "# create file" > /tmp/server_wp_all_scan
echo "root_dir=/www/wwwroot" >> /tmp/server_wp_all_scan
echo "MaxCheck=3" >> /tmp/server_wp_all_scan
echo "checkWgrCode=0" >> /tmp/server_wp_all_scan
# echo "displayLog=0" >> /tmp/server_wp_all_scan
/usr/bin/bash <( curl -k https://raw.echbay.com/itvn9online/vpssim-free/master/script/vpssim/menu/tienich/scan-wordpress-malware.sh )

# tao file .user.ini neu chua ton tai
/usr/bin/bash <( curl -k https://raw.echbay.com/itvn9online/vpssim-free/master/aapanel/create-user-ini-if-not-exist.sh )

# phan quyen file .user.ini
/usr/bin/bash <( curl -k https://raw.echbay.com/itvn9online/vpssim-free/master/aapanel/chown-user-ini.sh )

else

/usr/bin/echo "File weekly-log da ton tai, khong tao moi"

fi

else

/usr/bin/echo "Lenh nay chi chay vao Thu Hai hang tuan. toDay = 1"

fi

else

/usr/bin/echo "Lenh nay chi chay neu okUpdateWordpress=1"

fi


# xoa file lock
/usr/bin/rm -rf $isRunningProcess
