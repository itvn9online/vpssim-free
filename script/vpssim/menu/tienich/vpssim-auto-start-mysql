#!/bin/sh
if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
  if [ ! "$(/sbin/service mysql status | awk 'NR==1 {print $3}')" == "running" ]; then
rm -rf /var/lib/mysql/ib_logfile0
rm -rf /var/lib/mysql/ib_logfile1
service mysql start
/etc/init.d/mysql start
  fi
fi
#if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "7" ]; then 
if [ ! "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
  if [ ! "$(service mysql status | awk 'NR==1 {print $3}')" == "running" ]; then
rm -rf /var/lib/mysql/ib_logfile0
rm -rf /var/lib/mysql/ib_logfile1
service mysql start
/etc/init.d/mysql start
  fi
fi
