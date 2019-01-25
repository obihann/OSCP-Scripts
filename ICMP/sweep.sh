#!/bin/bash

A=$(echo $1 | cut -f 1 -d '.')
B=$(echo $1 | cut -f 2 -d '.')
C=$(echo $1 | cut -f 3 -d '.')
MIN=$(echo $1 | cut -f 4 -d '.')
MAX=$(echo $2 | cut -f 4 -d '.')
OUT=./Logs/live_ips_$(date +%Y%m%d).txt

touch $OUT
echo '' > $OUT

for (( i=$MIN; i<=$MAX; i++ )); do
   (ping -c 1 $A.$B.$C.$i | awk -F'bytes from ' '{print $2}' | cut -f 1 -d ':' -s) &
done 2>&1 | grep -v "No route" | tee $OUT
