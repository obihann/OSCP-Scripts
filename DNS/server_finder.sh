#!/bin/bash

GNMAP=nmap_dns_active_ips_$(date +%Y%m%d).gnmap
OUT=dns_servers_$(date +%Y%m%d).txt

IP_LIST=$1
NETWORK=$2

echo "find all dns servers for a list of IPs"
nmap -sT -p 53,139 -T5 --open -oG "$GNMAP" -iL "$IP_LIST" 2>&1 | tee "$OUT".log
cut -d ' ' -f 2 "$GNMAP" | sed '/^[0-9]/!d' | sort -u > "$OUT"

while read ip; do
	dnsrecon -r "$NETWORK" -n "$ip" 2>&1 | tee dnsrecon_"$ip"_"$(date +%Y%m%d)".log
done < "$OUT"
