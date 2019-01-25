#!/bin/bash

ipcalc() {
   echo $(/usr/bin/ipcalc -nb "$1" | grep -E "$2" | cut -d ' ' -f 4)
}

ADDRESS=$(ipcalc $1 "Address")
NETWORK=$(ipcalc $1 "Network")
HOSTMIN=$(ipcalc $1 "HostMin")
HOSTMAX=$(ipcalc $1 "HostMax")

IPS=$(./ICMP/sweep.sh $HOSTMIN $HOSTMAX)

echo "Live Hosts:"
for ip in $IPS; do 
   echo $ip

   mkdir -p Machines/$ip/Scanning \
      Machines/$ip/Enumeration \
      Machines/$ip/Exploitation \
      Machines/$ip/Logs \
      Machines/$ip/Notes \
      Machines/$ip/Post-Exploitation \
      Machines/$ip/Loot

done
  
./DNS/server_finder.sh ./Logs/live_ips_$(date +%Y%m%d).txt $NETWORK
