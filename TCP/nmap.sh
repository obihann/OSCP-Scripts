#!/bin/bash

IP=$1
DNS=$2

PRE=nmap_tcp
UNIQ="$IP"_"$(date +%Y%m%d)"
FOLDER=Machines/"$IP"/Scanning
DEFAULT_ARGS="-sT -T5 --open"
DNS_ARGS="--reason --dns-server $DNS"

oa() {
   echo -oA "$FOLDER"/"$PRE"_"$1"_"$UNIQ"
}

(
   echo "Light TCP scan on $IP"
   CMD="/usr/bin/nmap $DEFAULT_ARGS --top-ports 10 $(oa 'light') $IP"
   $CMD > ./Logs/"$PRE"_light_"$UNIQ".log 2>&1
   echo "Done light scan, check logs."
) &

(
   echo "Heavy TCP scan on $IP. Go get a coffee."
   CMD="/usr/bin/nmap $DEFAULT_ARGS $DNS_ARGS -p- -v -A $(oa 'heavy') $IP"
   $CMD > ./Logs/"$PRE"_heavy_"$UNIQ".log 2>&1
   echo "Done heavy scan, check logs."
) &

(
   echo "Extreme TCP scan on $IP. Go get lunch."
   CMD="/usr/bin/nmap $DEFAULT_ARGS $DNS_ARGS -p- -vv -A --script=default,vuln,discovery $(oa 'extreme') $IP"
   $CMD > ./Logs/"$PRE"_extreme_"$UNIQ".log 2>&1
   echo "Done extreme scan, check logs."
) &
