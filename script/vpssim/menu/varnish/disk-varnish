#!/bin/bash

disfree=$(calc $(df $PWD | awk '/[0-9]%/{print $(NF-2)}')/1024)
echo "Disk free: "$disfree

if [ -f /var/lib/varnish/varnish_storage.bin ]; then
#ls -l /var/lib/varnish/varnish_storage.bin
#ls -l --b=M /var/lib/varnish/varnish_storage.bin | cut -d " " -f5
current_varnish_storage=$(ls -l /var/lib/varnish/varnish_storage.bin | cut -d " " -f5)
#echo $current_varnish_storage
current_varnish_storage=$(($current_varnish_storage/1024/1024/1024))
echo "Current varnish storage: "$current_varnish_storage"G"
fi

#diskrecommended=$(($disfree/3*2/1024))
diskrecommended=$(($disfree/1024))

varnish_size=$(($current_varnish_storage+$diskrecommended))
varnish_size=$(($varnish_size-3))
echo "Disk cache recommended: "$varnish_size"G"
