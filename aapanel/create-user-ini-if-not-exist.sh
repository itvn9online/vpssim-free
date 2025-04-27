#!/bin/bash

# file nay duoc luu lai code cua echbay.com
# /echbay.com/bash-script/create-user-ini-if-not-exist.sh

# chuyen ve root truoc khi chay lenh
cd ~

# tao thu muc chua file .user.ini
/usr/bin/mkdir -p /tmp/wwwroot-user-ini && /usr/bin/chmod 755 /tmp/wwwroot-user-ini
for db_dir in /www/wwwroot/*
do
if [ ! -d $db_dir ]; then
continue
fi
/usr/bin/echo $db_dir
if [ -f $db_dir/.user.ini ]; then
continue
fi
dirname=$(basename -- "$db_dir")
/usr/bin/echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"$dirname
# tao file .user.ini
/usr/bin/cat > "/tmp/wwwroot-user-ini/.user.ini" <<END
open_basedir=/www/wwwroot/$dirname/:/tmp/
END
/usr/bin/chmod 644 /tmp/wwwroot-user-ini/.user.ini
/usr/bin/chown root:root /tmp/wwwroot-user-ini/.user.ini
/usr/bin/rsync -avzh /tmp/wwwroot-user-ini/.user.ini $db_dir/
done
