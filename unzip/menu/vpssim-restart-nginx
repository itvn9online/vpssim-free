#!/bin/bash 

if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
nginx -t
service nginx restart
else 
nginx -t
systemctl restart nginx
fi
