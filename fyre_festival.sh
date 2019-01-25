#!/bin/bash

ipcalc() {
   echo $(/usr/bin/ipcalc -nb "$1" | grep -E "$2" | cut -d ' ' -f 4)
}

ADDRESS=$(ipcalc $1 "Address")
NETWORK=$(ipcalc $1 "Network")
HOSTMIN=$(ipcalc $1 "HostMin")
HOSTMAX=$(ipcalc $1 "HostMax")

echo "Ping Sweep"
IPS=$(./ICMP/sweep.sh $HOSTMIN $HOSTMAX)

for ip in $IPS; do 
   mkdir -p Machines/$ip/Scanning \
      Machines/$ip/Enumeration \
      Machines/$ip/Exploitation \
      Machines/$ip/Logs \
      Machines/$ip/Notes \
      Machines/$ip/Post-Exploitation \
      Machines/$ip/Loot

   ./DNS/server_finder.sh live_ips_$(date +%Y%m%d).txt $NETWORK
   # ./TCP/nmap.sh $ip &
   # (echo "nmap light scan - $ip"; nmap -sT --top-ports 10 -T5 --open -oA Machines/$ip/Scanning/nmap_tcp_light_$ip_$(date +%Y%m%d.%s) $ip) &
done
