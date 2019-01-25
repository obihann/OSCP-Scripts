#!/bin/bash

GNMAP=./Logs/nmap_dns_active_ips_$(date +%Y%m%d).gnmap
OUT=./Logs/dns_servers_$(date +%Y%m%d).txt

IP_LIST=$1
NETWORK=$2

echo "DNS Servers:"
nmap -sT -p 53,139 -T5 --open -oG "$GNMAP" -iL "$IP_LIST" > /dev/null
cut -d ' ' -f 2 "$GNMAP" | sed '/^[0-9]/!d' | sort -u | tee "$OUT"

echo "Host Names:"
while read ip; do
   (dnsrecon -r "$NETWORK" -n "$ip" 2>&1 | awk -F 'PTR ' '{print $2}') &
done < "$OUT" | sed '/^\s*$/d' | sort -u | tee -a ./Logs/hosts_"$(date +%Y%m%d)".log
