#!/bin/sh
#
# Copyright (C) 2022 TurBoTse <860018505@qq.com>
#
#nvram set ntp_ready=0

mkdir -p /tmp/dnsmasq.dom
logger -t "To prevent DNSmasq from failing to start, create/tmp/dnsmasq.dom/"

smartdns_conf="/etc/storage/smartdns_custom.conf"
dnsmasq_Conf="/etc/storage/dnsmasq/dnsmasq.conf"
smartdns_Ini="/etc/storage/smartdns_conf.ini"
sdns_port=$(nvram get sdns_port)
if [ $(nvram get sdns_enable) = 1 ] ; then
   if [ -f "$smartdns_conf" ] ; then
       sed -i '/go to ad/d' $smartdns_conf
       sed -i '/adbyby/d' $smartdns_conf
       sed -i '/no-resolv/d' "$dnsmasq_Conf"
       sed -i '/server=127.0.0.1#'"$sdns_portd"'/d' "$dnsmasq_Conf"
       sed -i '/port=0/d' "$dnsmasq_Conf"
       rm  -f "$smartdns_Ini"
   fi
logger -t "autostart" "starting SmartDNS..."
/usr/bin/smartdns.sh start
fi

logger -t "autostart" "checking if the router is connected to the internet..."
count=0
while :
do
	ping -c 1 -W 1 -q 1.1.1.1 1>/dev/null 2>&1
	if [ "$?" == "0" ]; then
		break
	fi
	sleep 5
	ping -c 1 -W 1 -q one.one.one.one 1>/dev/null 2>&1
	if [ "$?" == "0" ]; then
		break
	fi
	sleep 5
	count=$((count+1))
	if [ $count -gt 18 ]; then
		break
	fi
done
