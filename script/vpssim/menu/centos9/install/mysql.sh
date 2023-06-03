#!/bin/bash
. /home/vpssim.conf

#
echo "=========================================================================="
echo "Install MariaDB..."
#sleep 2
yum install mariadb-server mariadb -y

#
systemctl start mariadb
systemctl enable mariadb
#systemctl status mariadb

#
#sudo mysqladmin version

#mysql_secure_installation

#
DATABASE_PASS=$passrootmysql

#
mysqladmin -u root password "$DATABASE_PASS"
# Make sure that NOBODY can access the server without a password
#mysql -u root -p"$DATABASE_PASS" -e "UPDATE mysql.user SET Password=PASSWORD('$DATABASE_PASS') WHERE User='root'"
#mysql -u root -p"$DATABASE_PASS" -e "SET PASSWORD FOR 'root'@localhost = PASSWORD('$DATABASE_PASS')"
# Kill the anonymous users
mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User=''"
# Kill off the demo database
mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
# Make our changes take effect
mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"
