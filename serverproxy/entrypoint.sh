#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
proxychains4 httpd-server -s "$SERVER_ADDR" -p "$SERVER_PORT" -m "$METHOD" -k "$PASSWORD"  -t "$TIMEOUT"  -d "$DNS_ADDR"   -u  --fast-open $OPTIONS > /dev/sdtout 2>&1 &
iptables -F
iptables -A INPUT -p tcp -m state --state NEW --dport $LIMIT_PORT -m connlimit --connlimit-above $LIMIT_CONN -j DROP
tc qdisc add dev eth0 root tbf rate $RATE burst $BURST latency $LATENCY
watch -n $INTERVAL tc -s qdisc ls dev eth0
