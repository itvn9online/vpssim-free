#!/bin/bash
if [ ! -f /tmp/server_wp_all_update ] && [ -f /home/vpssim.conf ]; then
. /home/vpssim.conf
fi

# update wordpress all
cd ~

/usr/bin/echo "# create file" > /tmp/server_wp_all_update
/usr/bin/echo "root_dir=\"www\"" >> /tmp/server_wp_all_update
# /usr/bin/echo "MaxCheck=3" >> /tmp/server_wp_all_update
# kiem tra da dung file htaccess cua WGR chua -> chi danh cho code cua WGR
/usr/bin/echo "checkWgrCode=0" >> /tmp/server_wp_all_scan
# tắt xmlrpc để nhẹ web và tăng bảo mật
/usr/bin/echo "DisableXmlrpc=1" >> /tmp/server_wp_all_update

#
if [ ! -d /etc/vpssim/menu/tienich ]; then
    /usr/bin/echo "Create dir /etc/vpssim/menu/tienich"
    /usr/bin/mkdir -p /etc/vpssim/menu/tienich
    /usr/bin/chmod 755 /etc/vpssim/menu/tienich
    /usr/bin/chown -R root:root /etc/vpssim/menu/tienich
fi

#
if [ -d /etc/vpssim/menu/tienich ]; then
    
    #cd /etc/vpssim/menu/tienich
    
    #
    if [ -f /etc/vpssim/menu/tienich/update-wordpress-for-all-site ]; then
        curTime=$(/usr/bin/date +%d%H)
        /usr/bin/echo "curTime: "$curTime
        
        fileTime2=$(/usr/bin/date -r /etc/vpssim/menu/tienich/update-wordpress-for-all-site +%d%H)
        /usr/bin/echo "fileTime2: "$fileTime2
        
        #
        if [ ! "$fileTime2" == "$curTime" ]; then
            /usr/bin/echo "Remove file /etc/vpssim/menu/tienich/update-wordpress-for-all-site by time"
            /usr/bin/rm -rf /etc/vpssim/menu/tienich/update-wordpress-for-all-site
        fi
    fi
    
    #
    if [ ! -f /etc/vpssim/menu/tienich/update-wordpress-for-all-site ]; then
        cd ~
        cd /etc/vpssim/menu/tienich
        /usr/bin/curl -sO https://raw.echbay.com/itvn9online/vpssim-free/master/script/vpssim/menu/tienich/update-wordpress-for-all-site
        cd ~
    fi
    
    #
    if [ -f /etc/vpssim/menu/tienich/update-wordpress-for-all-site ]; then
        /usr/bin/chmod +x /etc/vpssim/menu/tienich/update-wordpress-for-all-site

        f="/etc/vpssim/menu/tienich/update-wordpress-for-all-site"
        # Xóa tất cả các khoảng trắng ở đầu mỗi dòng.
        /usr/bin/sed -i -e 's/^[ \t]*//' $f

        # Xóa tất cả các khoảng trắng ở cuối mỗi dòng.
        /usr/bin/sed -i -e 's/ *$//' $f

        # Xóa các dòng trống
        /usr/bin/sed -i -e '/^$/d' $f
        
        #
        /usr/bin/sed -i 's/\r//' $f

        /usr/bin/bash /etc/vpssim/menu/tienich/update-wordpress-for-all-site
        
        /usr/bin/echo "server_wp_all_update"
    else
        /usr/bin/echo "ERROR_update_wordpress_for_all_site"
    fi
    
    cd ~

else
    /usr/bin/echo "ERROR_etc_vpssim_menu_tienich"
fi

/usr/bin/rm -rf /tmp/server_wp_all_update
