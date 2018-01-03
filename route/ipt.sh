#!/bin/bash

subnet="192.168.0.0/16"           # your subnet config
localaddr="192.168.0.2"           # this server ip (must be subnet ip)
boardcastaddr="192.168.0.255"
listenport=1080                   # local listen port (tcp)
udplistenport=0                   # set it if not the same udp port
NAT_OUTPUT=0                      # if 0: do not need to set server ip
if [ $NAT_OUTPUT -eq 1 ]; then
    serverip="100.86.100.10"          # ss server ip (tcp)
    serverip_udp=""                   # ss server ip (for udp), keep empty if the same
fi

iptables -t nat -D PREROUTING -p tcp -j SHADOWSOCKS
if [ $NAT_OUTPUT -eq 1 ]; then
    iptables -t nat -D OUTPUT -p tcp -j SHADOWSOCKS
fi
iptables -t nat -F SHADOWSOCKS
iptables -t nat -X SHADOWSOCKS

iptables -t mangle -D PREROUTING -p udp -j SHADOWSOCKS
iptables -t mangle -F SHADOWSOCKS
iptables -t mangle -X SHADOWSOCKS

ip rule del fwmark 0x01/0x01 table 100
ip route del local 0.0.0.0/0 dev lo table 100


if [ $udplistenport -eq 0 ]; then
    udplistenport=`expr $listenport`
fi

iptables -t nat -N SHADOWSOCKS
iptables -t nat -I PREROUTING -p tcp -j SHADOWSOCKS
if [ $NAT_OUTPUT -eq 1 ]; then
    iptables -t nat -I OUTPUT -p tcp -j SHADOWSOCKS
fi

ip rule add fwmark 0x01/0x01 table 100
ip route add local 0.0.0.0/0 dev lo table 100
iptables -t mangle -N SHADOWSOCKS
iptables -t mangle -A SHADOWSOCKS -d ${boardcastaddr} -j RETURN
iptables -t mangle -A SHADOWSOCKS -d 255.255.255.255/32 -j RETURN
iptables -t mangle -A SHADOWSOCKS -p udp --dport 137 -j RETURN
iptables -t mangle -A SHADOWSOCKS -p udp --dport 138 -j RETURN
iptables -t mangle -A SHADOWSOCKS -p udp -d ${localaddr} -j RETURN
iptables -t mangle -A SHADOWSOCKS -p udp -s ${localaddr} -j RETURN
iptables -t mangle -A SHADOWSOCKS -p udp -s ${subnet} -j TPROXY --on-port ${udplistenport} --tproxy-mark 0x01/0x01
iptables -t mangle -I PREROUTING -p udp -j SHADOWSOCKS

if [ $NAT_OUTPUT -eq 0 ]; then
    iptables -t nat -A SHADOWSOCKS -d ${localaddr} -j RETURN
    iptables -t nat -A SHADOWSOCKS -s ${localaddr} -j RETURN
else
    iptables -t nat -A SHADOWSOCKS -d ${serverip} -j RETURN
    iptables -t nat -A SHADOWSOCKS -s ${serverip} -j RETURN
    if [ -z $serverip_udp ]; then
        iptables -t nat -A SHADOWSOCKS -d ${serverip} -j RETURN
        iptables -t nat -A SHADOWSOCKS -s ${serverip} -j RETURN
    fi
fi

iptables -t nat -A SHADOWSOCKS -d 127.0.0.0/8 -j RETURN
iptables -t nat -A SHADOWSOCKS -d ${subnet} -j RETURN

iptables -t nat -A SHADOWSOCKS -p tcp -j REDIRECT --to-ports ${listenport}
