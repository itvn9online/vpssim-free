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

echo "File log da ton tai, khong tao moi"

fi


# xoa file lock
/usr/bin/rm -rf $isRunningProcess
