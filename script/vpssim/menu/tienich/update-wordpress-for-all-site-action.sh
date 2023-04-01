#!/bin/bash
if [ ! -f /tmp/server_wp_all_update ] && [ -f /home/vpssim.conf ]; then
. /home/vpssim.conf
fi



# chuc nang cap nhat wordress cho toan bo website tren server
for_classic_editor="classic-editor.1.6.2"
for_yoast_seo="wordpress-seo.20.4"
for_elementor="elementor.3.11.5"


echoY() {
    echo -e "\033[38;5;148m${1}\033[39m"
}
echoG() {
    echo -e "\033[38;5;71m${1}\033[39m"
}
echoR()
{
    echo -e "\033[38;5;203m${1}\033[39m"
}


# dọn dẹp file php trong thư mục wp-content, themes, plugins -> hạn chế tối đa mã độc ẩn chứa trong này
remove_php_in_wp_content(){
	if [ -d $1 ]; then
		rm -rf $1/*.php
		rm -rf $1/.htaccess
		echo "No money... No love..." > $1/index.php
	fi
}

remove_code_and_htaccess(){
	rm -rf $1/*
	rm -rf $1/.htaccess
}


#
cd ~
echo $(date) > /root/update-wordpress-for-all-site-log.txt

#
checkWgrCode=0
chmodUser=""
home_path="/home/"
DisableXmlrpc=0
for_rebuild="no"

# cau hinh linh dong theo tung loai host
if [ -f /tmp/server_wp_all_update ]; then

. /tmp/server_wp_all_update

else

sleep 2
clear
echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"

# con lai se cho nguoi dung nhap path
echo -n "Enter folder for check and update (default /home): "
read root_dir
if [ "$root_dir" == "" ]; then
	root_dir="/home"
else
	# xac dinh user dung de chmod
	if [ ! "$root_dir" == "/home" ] && [[ ! "$root_dir" == *"$home_path"* ]]; then
		echo -n "chmod to user (default: auto detect): "
		read chmodUser
	fi
fi
if [ ! -d $root_dir ]; then
	echoR $root_dir" not exist..."
	exit
fi

#
echo -n "Maximum folder for foreach (maximum 10, default 3): "
read MaxCheck
if [ "$MaxCheck" == "" ]; then
	MaxCheck=3
fi

#
echo -n "Disable Wordpress Xmlrpc (default: y | Please choose: y/n): "
read removeXmlrpc
if [ "$removeXmlrpc" == "" ] || [ "$removeXmlrpc" == "y" ]; then
	DisableXmlrpc=1
fi

fi

echoG "OK OK, check and update wordpres website in: "$root_dir
echo "Max for: "$MaxCheck
echo "Disable Xmlrpc: "$DisableXmlrpc
echo "User: "$chmodUser
echoY "Will begin after 2s..."
#echo "TEST: "$root_dir
#exit
sleep 2



# install rsync if not exist
#current_os_version=$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))

#rm -rf /root/test_rsync_for_wp_all_update
echo "Hello world..." > /tmp/test_rsync_for_wp_all_update
rsync -ah /tmp/test_rsync_for_wp_all_update /root

#
if [ ! -f /root/test_rsync_for_wp_all_update ]; then
echoY "Install rsync"
yum -y install rsync > /dev/null 2>&1
fi

rsync -ah /tmp/test_rsync_for_wp_all_update /root
if [ ! -f /root/test_rsync_for_wp_all_update ]; then
echoR "Rsync ERROR......."
exit
fi


# cap nhat cho cac file download
curTime=$(date +%d%H)
echo "curTime: "$curTime


# kiem tra va xoa cac file download cu
check_and_remmove_file_download(){

# $1 -> ten file can kiem tra -> thuong la .zip
# $2 -> thu muc con (neu co)

if [ ! "$2" == "" ]; then
mkdir -p /root/wp-all-update$2
cd /root/wp-all-update$2
else
cd /root/wp-all-update
fi

# kiem tra file size
if [ -f $1 ]; then
downloadSize=$(du -h $1 | awk 'NR==1 {print $1}')
if [ "$downloadSize" == "0" ]; then
echoR "Remove file... Filesize zero: "$1
rm -rf $1
fi
fi

# kiem tra xem file download wordress co chua
if [ -f $1 ]; then
#fileTime2=$(date -r $1 +%d)
fileTime2=$(date -r $1 +%d%H)
echo "fileTime2: "$fileTime2

# neu file duoc download lau roi -> cap nhat lai
if [ ! "$fileTime2" == "$curTime" ]; then

# xoa ca thu muc neu la file wp.zip
if [ "$1" == "wp.zip" ]; then
remove_code_and_htaccess /root/wp-all-update
else
rm -rf $1
fi

else
echo "download exist: "$1
fi

fi

cd ~

}


#
mkdir -p /root/wp-all-update
#cd /root/wp-all-update

# timestamp
#timest=$(date +%s)
#echo "timest: "$timest


download_and_unzip_file(){

# $1 -> URL file download
# $2 -> ten file download xong con luu lai -> thuong la .zip
# $3 -> luu vao thu muc con (neu co)
# $4 -> xoa thu muc cu (neu co)

check_and_remmove_file_download $2 $3

if [ ! "$3" == "" ]; then
mkdir -p /root/wp-all-update$3
cd /root/wp-all-update$3
else
cd /root/wp-all-update
fi

if [ ! -f $2 ]; then
#echo "Download: "$1
echo "Start download: "$2
wget --no-check-certificate -q $1 -O $2 && chmod 755 $2

# khong download duoc -> thoat
if [ ! -f $2 ]; then
echoR "Download faild... File not exist: "$2
exit
fi

# kiem tra file size
downloadSize=$(du -h $2 | awk 'NR==1 {print $1}')
if [ "$downloadSize" == "0" ]; then
echoR "Download faild... Filesize zero: "$2
exit
fi

# thay doi thoi gian tao file cung voi server, de con kiem tra cap nhat lai code
echo "Set timestamp: "$2 ; touch -d "$(date)" $2

# giai nen
unzip -o $2 > /dev/null 2>&1
#else
#echo $2" exist"
fi

cd ~

}


# wordpres
download_and_unzip_file "https://wordpress.org/latest.zip" "wp.zip" ""
#download_and_unzip_file "https://echbay.com/daoloat/latest-vi.zip" "wp.zip" ""

file_optimize(){
f=$1
echo $f
# remove blank in first line
sed -i -e "s/^\s*//" $f
# remove blank in last line
sed -i -e "s/\s*$//" $f
# remove single comment line
sed -i -e '/^\s*\/\/.*$/d' $f
# remove blank in first line
sed -i -e "s/^\s*//" $f
# remove blank in last line
sed -i -e "s/\s*$//" $f
# remove blank line
sed -i -e "/^$/d" $f
sed -i -e '/^\s*$/d' $f
}

remove_single_comment_line(){
if [ -d $1 ]; then
	for optimize_dir in $1/*
	do
		if [ -f $optimize_dir ]; then
			#echo $optimize_dir
			file_optimize $optimize_dir
		fi
	done
fi
}

# echbaydotcom
download_and_unzip_file "https://github.com/itvn9online/echbaydotcom/archive/master.zip" "echbaydotcom.zip" ""
remove_single_comment_line "/root/wp-all-update/echbaydotcom-master/javascript"
remove_single_comment_line "/root/wp-all-update/echbaydotcom-master/css"

download_and_unzip_file "https://github.com/itvn9online/webgiareorg/archive/refs/heads/main.zip" "webgiareorg.zip" ""
remove_single_comment_line "/root/wp-all-update/webgiareorg-main/public/javascript"
remove_single_comment_line "/root/wp-all-update/webgiareorg-main/public/css"

download_and_unzip_file "https://github.com/itvn9online/echbaytwo/archive/master.zip" "echbaytwo.zip" ""
remove_single_comment_line "/root/wp-all-update/echbaytwo-master/javascript"
remove_single_comment_line "/root/wp-all-update/echbaytwo-master/css"
#exit

# download wordpress plugin hay dung nhat -> moi cap nhat chuc nang tim va download tu dong -> khong can phai thiet lap thu cong nua
download_wordpress_plugin(){
echoY "- - - - - - - - - Download new plugin: "$1" save to "$2
download_and_unzip_file "https://downloads.wordpress.org/plugin/"$1".zip" $2".zip" "/plugins"
}

re_download_plugin=""

rsync_wp_plugin(){

# $1 -> thu muc nguon
# $2 -> thu muc dich
# $3 -> lap lai hay khong, chi cho lap lai 1 lan

#echo $1
#echo $2

#download_wordpress_plugin $1

#echo $2/wp-content/plugins/$1

# plugin duoc tai ve roi thi thuc hien update
if [ -d "$2/wp-content/plugins/$1" ] && [ -d "/root/wp-all-update/plugins/$1" ]; then
	# xoa code cu di da
	echoY "cleanup - - - "$1
	remove_code_and_htaccess $2/wp-content/plugins/$1
	# sau do moi rsync
	echoG "rsync - - - "$1
	rsync -ah /root/wp-all-update/plugins/$1/* $2/wp-content/plugins/$1/ > /dev/null 2>&1
# chua duoc tai thi download ve
elif [ ! "$3" == "no" ]; then
	file404=/root/wp-all-update/plugins/---$1
	file500=/root/wp-all-update/plugins/-$1
	if [ ! -f $file404 ]; then
		# voi 1 so plugin, phai chi dinh ro ca phien ban can cap nhat
		download_version=$1
		if [ "$1" == "wordpress-seo" ]; then
			download_version=$for_yoast_seo
		elif [ "$1" == "classic-editor" ]; then
			download_version=$for_classic_editor
		elif [ "$1" == "elementor" ]; then
			download_version=$for_elementor
		fi

		# kiem tra xem plugin nay co tren wordpress khong
		ketnoi="https://downloads.wordpress.org/plugin/"$download_version".zip"
		ketnoi=$(curl -o /dev/null --silent --head --write-out '%{http_code}' $ketnoi)
		#ketnoi=$(curl -o /dev/null --silent --head --write-out '%{http_code}' "https://downloads.wordpress.org/plugin/"$1".zip")
		#echo $ketnoi
		# neu co thi download ve de cap nhat cho website
		if [ "$ketnoi" == "200" ]; then
			download_wordpress_plugin $download_version $1
			sleep 1
			rsync_wp_plugin $1 $2 "no"
		elif [ "$ketnoi" == "404" ]; then
			# neu khong thi bao loi, thuong thi nhung plugin pro se khong co tren wordpress
			echoR "- - - - - - - - - WARNING... plugin not exist ("$ketnoi"): "$1
			# tao file de qua trinh kiem tra ket noi khong dien ra lien tuc
			echo $ketnoi > $file404

			#
			send_warning_via_telegram $2"/"$1 "plugins_404"
		else
			# neu khong thi bao loi, thuong thi nhung plugin pro se khong co tren wordpress
			echoY "- - - - - - - - - WARNING... plugin connect error "$ketnoi": "$1
			# tao file de qua trinh kiem tra ket noi khong dien ra lien tuc
			echo $ketnoi > $file500

			# download lai lan nua neu phat hien ra file khong ket noi duoc
			re_download_plugin="1"
		fi
	else
		echoR "- - - - - - - - - WARNING... plugin not exist (cache): "$1
	fi
else
	echoR "Re-download plugin faild: "$1
fi
}


# don dep code sau khi download
cd ~

# xoa thu muc wp-content
if [ -d /root/wp-all-update/wordpress/wp-content ]; then
remove_code_and_htaccess /root/wp-all-update/wordpress/wp-content
rm -rf /root/wp-all-update/wordpress/wp-content
fi

# khong ton tai wordpress -> thoat
if [ ! -d /root/wp-all-update/wordpress ]; then
echo "wordpress not exist"
exit
fi

# unzip echbaydotcom
if [ -d /root/wp-all-update/echbaydotcom-master ]; then
rm -rf /root/wp-all-update/echbaydotcom-master/.gitattributes
rm -rf /root/wp-all-update/echbaydotcom-master/.gitignore
# chinh lai thoi gian cap nhat
if [ -f /root/wp-all-update/echbaydotcom-master/readme.txt ]; then
	touch -d "$(date)" /root/wp-all-update/echbaydotcom-master/readme.txt
fi

# unzip code trong outsource cua echbaydotcom
cd ~
if [ -d /root/wp-all-update/echbaydotcom-master/outsource ]; then
cd /root/wp-all-update/echbaydotcom-master/outsource
for f_unzip in ./*.zip
do
echo $f_unzip
unzip -o $f_unzip > /dev/null 2>&1
done
cd ~
fi

fi
# END unzip echbaydotcom

# unzip webgiareorg
if [ -d /root/wp-all-update/webgiareorg-main ]; then
rm -rf /root/wp-all-update/webgiareorg-main/.gitattributes
rm -rf /root/wp-all-update/webgiareorg-main/.gitignore
# chinh lai thoi gian cap nhat
if [ -f /root/wp-all-update/webgiareorg-main/README.md ]; then
	touch -d "$(date)" /root/wp-all-update/webgiareorg-main/README.md
fi

# unzip code trong public thirdparty cua webgiareorg
cd ~
if [ -d /root/wp-all-update/webgiareorg-main/public/thirdparty ]; then
cd /root/wp-all-update/webgiareorg-main/public/thirdparty
for f_unzip in ./*.zip
do
echo $f_unzip
unzip -o $f_unzip > /dev/null 2>&1
done
cd ~
fi

fi
# END unzip webgiareorg

# unzip echbaytwo
if [ -d /root/wp-all-update/echbaytwo-master ]; then
rm -rf /root/wp-all-update/echbaytwo-master/.gitattributes
rm -rf /root/wp-all-update/echbaytwo-master/.gitignore
# chinh lai thoi gian cap nhat
if [ -f /root/wp-all-update/echbaytwo-master/index.php ]; then
	touch -d "$(date)" /root/wp-all-update/echbaytwo-master/index.php
fi

# unzip code trong outsource cua echbaytwo
cd ~
if [ -d /root/wp-all-update/echbaytwo-master/outsource ]; then
cd /root/wp-all-update/echbaytwo-master/outsource
for f_unzip in ./*.zip
do
echo $f_unzip
unzip -o $f_unzip > /dev/null 2>&1
done
cd ~
fi

fi
# END unzip echbaytwo

# phan quyen cho nginx quan ly
id -u nginx
if [ $? -eq 0 ]; then
	chown -R nginx:nginx /root/wp-all-update
fi


#exit
cd ~

# kiem tra neu co file la thi dua ra canh bao
check_wp_suspect_malware_file(){
echoY "Check malware..."
checkFile=$1/index.php
if [ -f $checkFile ]; then
	# thu tim chuoi base64 decode trong file index php -> mac dinh thi file index php khong co doan nay
	if grep -q base64_decode "$checkFile"; then
		# gui canh bao ve telegram
		send_warning_via_telegram $1 "index"
	fi
fi
# file wp-login php la noi no thu thap thong tin dang nhap cua nguoi dung
checkFile=$1/wp-login.php
if [ -f $checkFile ]; then
	# thu tim chuoi logo.gif trong file wp-login php -> mac dinh thi file wp-login php khong co doan nay
	if grep -q logo.gif "$checkFile"; then
		# gui canh bao ve telegram
		send_warning_via_telegram $1 "wp-login"
	fi
fi
# file logo.gif nay cung do virus tao ra
if [ -f $1/logo.gif ]; then
	# gui canh bao ve telegram
	send_warning_via_telegram $1 "logogif"
fi

# kiem tra cac file khong dung chuan cua wordpress
wp_prefix="wp-"
for get_wp_f in $1/*
do
	if [ -f $get_wp_f ]; then
		filename=$(basename -- "$get_wp_f")
		extension="${filename##*.}"
		# neu la file php -> kiem tra xem co chu wp- o dau file khong
		if [ "$extension" == "php" ] && [ ! "$filename" == "index.php" ] && [ ! "$filename" == "xmlrpc.php" ]; then
			if [[ ! "$filename" == *"$wp_prefix"* ]]; then
				# gui canh bao ve telegram
				send_warning_via_telegram $1 $filename
			fi
		fi
	fi
done

# kiem tra da dung file htaccess cua WGR chua -> chi danh cho code cua WGR
if [ "$checkWgrCode" -ne 0 ]; then
	checkFile=$1/.htaccess
	# khong co file htaccess -> bao loi
	if [ ! -f $checkFile ]; then
		send_warning_via_telegram $1 "no_htaccess"
		update_default_htaccess $1
	else
		# thu tim chuoi www.old-domain.com trong file htaccess -> neu khong co thi khong phai file chuan cua WGR
		if grep -q www.old-domain.com "$checkFile"; then
			echoG "htaccess OK..."
		else
			# gui canh bao ve telegram
			send_warning_via_telegram $1 "wgr_htaccess"
			# update lai htaccess neu dang o thu muc public html
			is_public_html=$(basename $1)
			if [ "$is_public_html" == "public_html" ]; then
				update_default_htaccess $1
			fi
		fi
	fi
fi
}

send_warning_via_telegram(){
	#wget --no-check-certificate -O /dev/null "https://cloud.echbay.com/backups/has_malware?source="$2"&path="$1
	curl --data "source="$2"&path="$1 https://cloud.echbay.com/backups/has_malware
	echoY $2
}

# cap nhat lai file htaccess theo tieu chuan neu co yeu cau
update_default_htaccess(){
	yes | cp -rf /etc/vpssim/menu/tienich/.htaccess $1/.htaccess
	echoG "UPDATE htaccess..."
	for_rebuild="yes"
}

# tim tat ca thu muc trong home
get_all_dir_in_dir(){
echo "--------------------------------------------------------"
echo "Dir scan: "$1
echo "Re-scan: "$2
echo "Max scan: "$3
echo "Host user: "$4

# do sau toi da se kiem tra
if [ $2 -lt $3 ]; then
	for get_d in $1
	do
		# neu la thu muc thi kiem tra tiep
		if [ -d $get_d ]; then
			# neu la shortcut thi bo qua
			if [ -L $get_d ]; then
				echo $get_d"::It is a symlink..."
			else
				# tim it nhat 3 file va 3 thu muc bat buoc phai co cua wp
				if [ -f $get_d/wp-config.php ] && [ -d $get_d/wp-admin ] && [ -d $get_d/wp-content ] && [ -d $get_d/wp-includes ]; then
					# tim duoc website wp
					echoG $get_d"::It is a wordpress website"
					
					# thu kiem tra xem site nay co dinh malware khong
					check_wp_suspect_malware_file $get_d

					echo "Begin rsync... Please wait..."
					
					# wordpres core
					if [ -d /root/wp-all-update/wordpress ]; then
						#echoG "rsync - - - wordpress CORE..."
						# đồng bộ đồng thời xóa các file .php dư thừa -> chống virus
						rm -rf $get_d/wp-config.txt
						if [ -f $get_d/wp-config.php ]; then
							echoG "Backup wp-config..."
							mv -f $get_d/wp-config.php $get_d/wp-config.txt
						fi
						echoY "cleanup - - - PHP"
						rm -rf $get_d/*.php
						# rsync -avz
						echoG "rsync - - - PHP"
						rsync -ah --exclude="wp-config.php" --exclude="wp-admin/*" --exclude="wp-content/*" --exclude="wp-includes/*" /root/wp-all-update/wordpress/*.php $get_d/ > /dev/null 2>&1
						if [ -f $get_d/wp-config.txt ]; then
							echoG "Restore wp-config..."
							mv -f $get_d/wp-config.txt $get_d/wp-config.php
						fi
						# đồng bộ thư mục admin và includes
						if [ -d /root/wp-all-update/wordpress/wp-admin ]; then
							echoY "cleanup - - - wp-admin..."
							remove_code_and_htaccess $get_d/wp-admin
							rm -rf $get_d/wp-admin
							echoG "rsync - - - wp-admin..."
							rsync -ah /root/wp-all-update/wordpress/wp-admin $get_d/ > /dev/null 2>&1
							rsync -ah /root/wp-all-update/wordpress/wp-admin/* $get_d/wp-admin/ > /dev/null 2>&1
						fi
						if [ -d /root/wp-all-update/wordpress/wp-includes ]; then
							echoY "cleanup - - - wp-includes..."
							remove_code_and_htaccess $get_d/wp-includes
							rm -rf $get_d/wp-includes
							echoG "rsync - - - wp-includes..."
							rsync -ah /root/wp-all-update/wordpress/wp-includes $get_d/ > /dev/null 2>&1
							rsync -ah /root/wp-all-update/wordpress/wp-includes/* $get_d/wp-includes/ > /dev/null 2>&1
						fi
						echoY "cleanup - - - wp-content..."
						remove_php_in_wp_content $get_d/wp-content
						remove_php_in_wp_content $get_d/wp-content/plugins
						remove_php_in_wp_content $get_d/wp-content/themes
						# đồng bộ nốt các thư mục và file còn lại
						echoG "rsync - - - wp-index..."
						rsync -ah --exclude="wp-config.php" --exclude="wp-admin/*" --exclude="wp-content/*" --exclude="wp-includes/*" /root/wp-all-update/wordpress/* $get_d/ > /dev/null 2>&1
							
						#
						if [ "$DisableXmlrpc" -ne 0 ]; then
							# tắt xmlrpc để nhẹ web và tăng bảo mật
							echoG "Disable Xmlrpc..."
							echo "Hello world..." > $get_d/xmlrpc.php
						fi

					fi

					# chi su dung echbaydotcom hoac webgiareorg
					if [ -d "$get_d/wp-content/echbaydotcom" ] && [ -d "$get_d/wp-content/webgiareorg" ]; then
						# neu co echbaytwo
						if [ -d "$get_d/wp-content/themes/echbaytwo" ]; then
							# xoa webgiareorg
							rm -rf $get_d/wp-content/webgiareorg/*
							rm -rf $get_d/wp-content/webgiareorg
						elif [ -d "$get_d/wp-content/themes/flatsome" ]; then
							# xoa echbaydotcom
							rm -rf $get_d/wp-content/echbaydotcom/*
							rm -rf $get_d/wp-content/echbaydotcom
						fi
					fi

					# echbaydotcom
					if [ -d /root/wp-all-update/echbaydotcom-master ] && [ -d "$get_d/wp-content/echbaydotcom" ]; then
						# nếu tồn tại cả thư mục webgiareorg -> cảnh báo ngay
						if [ -d "$get_d/wp-content/webgiareorg" ]; then
							echoR "echbaydotcom AND webgiareorg EXIST..."
							echo $get_d >> /root/update-wordpress-for-all-site-log.txt
							#sleep 30;
						fi
						
						echoY "cleanup - - - echbaydotcom..."
						remove_code_and_htaccess $get_d/wp-content/echbaydotcom
						echoG "rsync - - - echbaydotcom..."
						rsync -ah /root/wp-all-update/echbaydotcom-master/* $get_d/wp-content/echbaydotcom/ > /dev/null 2>&1
						#chown -R nginx:nginx $get_d/wp-content/echbaydotcom

						# echbaytwo
						if [ -d /root/wp-all-update/echbaytwo-master ] && [ -d "$get_d/wp-content/themes/echbaytwo" ]; then
							echoY "cleanup - - - echbaytwo..."
							remove_code_and_htaccess $get_d/wp-content/themes/echbaytwo
							echoG "rsync - - - echbaytwo..."
							rsync -ah /root/wp-all-update/echbaytwo-master/* $get_d/wp-content/themes/echbaytwo/ > /dev/null 2>&1
							#chown -R nginx:nginx $get_d/wp-content/themes/echbaytwo
							
							# copy file index-tmp.php de active WP_ACTIVE_WGR_SUPPER_CACHE luon va ngay
							if [ -f "$get_d/wp-content/echbaydotcom/index-tmp.php" ]; then
								echoG "active WP ACTIVE WGR SUPPER CACHE..."
								yes | cp -rf $get_d/wp-content/echbaydotcom/index-tmp.php $get_d/index.php
							fi
						fi
					fi
					
					# webgiareorg
					if [ -d /root/wp-all-update/webgiareorg-main ] && [ -d "$get_d/wp-content/webgiareorg" ]; then
						# và không được có theme echbaytwo
						if [ -d "$get_d/wp-content/themes/echbaytwo" ]; then
							echoY "continue - - - echbaytwo..."
						# chỉ chạy khi có theme flatsome đi kèm
						elif [ -d "$get_d/wp-content/themes/flatsome" ]; then
							echoY "cleanup - - - webgiareorg..."
							remove_code_and_htaccess $get_d/wp-content/webgiareorg
							echoG "rsync - - - webgiareorg..."
							rsync -ah /root/wp-all-update/webgiareorg-main/* $get_d/wp-content/webgiareorg/ > /dev/null 2>&1
							#chown -R nginx:nginx $get_d/wp-content/webgiareorg
							
							# copy file index-tmp.php de active WP_ACTIVE_WGR_SUPPER_CACHE luon va ngay
							if [ -f "$get_d/wp-content/webgiareorg/index-tmp.php" ]; then
								echoG "active WP ACTIVE WGR SUPPER CACHE..."
								yes | cp -rf $get_d/wp-content/webgiareorg/index-tmp.php $get_d/index.php
							fi
						else
							echoR "webgiareorg for flatsome ONLY..."
						fi
					fi

					# dọn dẹp code dư thừa của backup
					echoY "Cleanup EB update code..."
					rm -rf $get_d/wp-content/echbaydotcom-*
					rm -rf $get_d/wp-content/themes/echbaytwo-*
					rm -rf $get_d/wp-content/webgiareorg-*
					# dọn dẹp file thừa do lỗi update của webgiareorg trước đây
					rm -rf $get_d/EB_THEME_CACHE-*
					
					# wordpres plugin -> chay vong lap va update tat ca neu co
					#if [ -d /root/wp-all-update/plugins ]; then
					if [ -d "$get_d/wp-content/plugins" ]; then
						#for plugins_dir in /root/wp-all-update/plugins/*
						for plugins_dir in $get_d/wp-content/plugins/*
						do
							if [ -d $plugins_dir ]; then
								pl_dir=$(basename $plugins_dir)
								#echo $pl_dir
								rsync_wp_plugin $pl_dir $get_d ""
							fi
						done
					fi
					
					if [ ! "$4" == "" ]; then
						id -u $4
						if [ $? -eq 0 ]; then
							echo "chown user: "$4
							
							# voi DirectAdmin -> chuyen quyen cho user
							if [ -f /etc/init.d/directadmin ]; then
								chown -R $4:$4 $get_d
								chown -R $4:$4 $get_d/*
							else
								# voi VPSSIM, HOCVPS -> phan quyen cho user va nginx
								id -u nginx
								if [ $? -eq 0 ]; then
									chown -R $4:nginx $get_d
									chown -R $4:nginx $get_d/*
								else
									chown -R $4:$4 $get_d
									chown -R $4:$4 $get_d/*
								fi
							fi
						else
							echo "user "$4" not exist"
						fi
					fi
					
					echo "Rsync all DONE..."
					sleep 3;
				# thử xem có phải là laravel hoặc codeigniter không
				elif [ -f $get_d/code-mau.php ] && [ -d $get_d/app ] && [ -d $get_d/public ] && [ -d $get_d/system ]; then
					# tim duoc website wp
					echoY $get_d"::It is a Laravel or Codeigniter website"
					
					echoG "Begin cleanup... Please wait..."

					# dọn rác update trên này
					echo $get_d"/system-*"
					rm -rf $get_d/system-*

					echoG "Cleanup all DONE..."
					sleep 3;
				else
					#echo $get_d
					stt=$2
					let "stt+=1"
					#echo $stt
					get_all_dir_in_dir $get_d"/*" $stt $3 $4
				fi
			fi
		fi
	done
fi
}


# lap tim cac website trong thu muc home
WP_update_main(){
echoG "Check WP update in: "$root_dir
#exit

# voi cac thu muc khac, quet thang trong thu muc
if [ ! "$root_dir" == "/home" ]; then
	get_all_dir_in_dir $root_dir"/*" 0 $MaxCheck $host_user
else

# voi thu muc home thi moi can do theo host
for main_dir in $root_dir/*
do
	# neu la thu muc -> tim cac file wp trong nay
	if [ -d $main_dir ]; then
		echo "d home: "$main_dir
		
		# tai khoan de chmod file sau khi update
		if [ "$chmodUser" == "" ]; then
			host_user=$(basename $main_dir)
		else
			host_user=$chmodUser
		fi
		echo "host user: "$host_user
		
		get_all_dir_in_dir $main_dir"/*" 0 $MaxCheck $host_user
		
		echo "========================================"
	fi
done

fi

}
WP_update_main

#
if [ ! "$re_download_plugin" == "" ]; then
echoY "Re-update after 10s"
sleep 10
WP_update_main
fi

#
cd ~
if [ ! "$for_rebuild" == "no" ]; then
	if [ -f /usr/local/lsws/bin/lswsctrl ]; then
		/usr/local/lsws/bin/lswsctrl restart
	else
		/bin/systemctl reload nginx.service
	fi
fi

#
cd ~
echo $(date) >> /root/update-wordpress-for-all-site-log.txt

#
if [ ! -f /tmp/server_wp_all_update ] && [ -f /home/vpssim.conf ]; then
/etc/vpssim/menu/vpssim-tien-ich
fi
