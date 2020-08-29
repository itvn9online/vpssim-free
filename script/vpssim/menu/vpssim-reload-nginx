#!/bin/bash 

if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
nginx -t
service nginx reload
else 
nginx -t
systemctl reload nginx
fi
