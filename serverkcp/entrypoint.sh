#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
# 设置端口变量设置为SS端口+100
KCP_PORT=`expr $SERVER_PORT + 100`
UDPSPEED_PORT=`expr $SERVER_PORT + 99`
UDP2RAW_PORT=`expr $SERVER_PORT + 100`
# 在线获得服务器IP
get_ip() {
	ip=$DOMAIN
	[[ -z $ip ]] && ip=$(curl -s https://ipinfo.io/ip)
	[[ -z $ip ]] && ip=$(curl -s https://api.ip.sb/ip)
	[[ -z $ip ]] && ip=$(curl -s https://api.ipify.org)
	[[ -z $ip ]] && ip=$(curl -s https://ip.seeip.org)
	[[ -z $ip ]] && ip=$(curl -s https://ifconfig.co/ip)
	[[ -z $ip ]] && ip=$(curl -s https://api.myip.com | grep -oE "([0-9]{1,3}\.){3}[0-9]{1,3}")
	[[ -z $ip ]] && ip=$(curl -s icanhazip.com)
	[[ -z $ip ]] && ip=$(curl -s myip.ipip.net | grep -oE "([0-9]{1,3}\.){3}[0-9]{1,3}")
	[[ -z $ip ]] && echo -e "\n$red 这垃圾小鸡扔了吧！$none\n" && exit
}

get_ip

# 打印输出SS配置信息
echo
echo "---------- shadowsocks 配置信息 -------------"
echo "地址 (Address) = ${ip}"
echo
echo "SS端口 (tcp/udp) = $SERVER_PORT"
echo
echo "KCP端口 (udp) = $KCP_PORT"
echo
echo "UDPSPEED端口 (udp) = $UDPSPEED_PORT"
echo
echo "UDP2RAW端口 (tcp) = $UDP2RAW_PORT"
echo
echo "ss+kcp+udp2raw用户密码 (password) = $PASSWORD"
echo
echo "加密协议 (xchacha20-ietf-poly1305 | aes-256-gcm ) = $METHOD"
echo
echo "----------------- END ----------------------"
echo

# 后台启动SS进程
httpd-server -s "$SERVER_ADDR" -p "$SERVER_PORT" -m "$METHOD" -k "$PASSWORD"  -t "$TIMEOUT"  -d "$DNS_ADDR"   -u  --fast-open $OPTIONS > /dev/sdtout 2>&1 &

# 启动KCP进程
KCP_PORT=`expr $SERVER_PORT + 100`
server_linux_amd64 -t "127.0.0.1:$SERVER_PORT" -l ":$KCP_PORT" --key="$PASSWORD" $KCP_OPTIONS > /dev/sdtout 2>&1 &

# 启动UDPspeedv2进程

UDPSPEED_PORT=`expr $SERVER_PORT + 99`
/usr/bin/speederv2 -s -l 127.0.0.1:$UDPSPEED_PORT -r 127.0.0.1:$SERVER_PORT -f2:4 --mode 0 --timeout 0 /dev/sdtout 2>&1 &

#启动udp2raw-tunnel进程
UDP2RAW_PORT=`expr $SERVER_PORT + 100`
/usr/bin/udp2raw-tunnel -s -l 0.0.0.0:$UDP2RAW_PORT -r 127.0.0.1:$UDPSPEED_PORT  --raw-mode faketcp -k $PASSWORD /dev/sdtout 2>&1

