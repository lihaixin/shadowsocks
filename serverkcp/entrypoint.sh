#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
KCP_PORT=`expr $SERVER_PORT + 1`
httpd-server -s "$SERVER_ADDR" -p "$SERVER_PORT" -m "$METHOD" -k "$PASSWORD"  -t "$TIMEOUT"  -d "$DNS_ADDR"   -u  --fast-open $OPTIONS > /dev/sdtout 2>&1 &
sleep 2
server_linux_amd64 -t "127.0.0.1:$SERVER_PORT" -l ":$KCP_PORT" --key="$PASSWORD" $KCP_OPTIONS
