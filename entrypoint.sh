#!/bin/bash

set -ex

sysctl -p

Client_IPv4=$(ip route get 8.8.8.8 | grep 'src' | awk -F 'src' '{print $2}' | awk '{print $1}')

if [ ! -z $Server_IPv4 ] && [ ! -z $Client_IPv6 ] && [ ! -z $Client_IPv4 ]; then
    ip tunnel add 6in4-tunnel mode sit remote $Server_IPv4 local $Client_IPv4 ttl 255
    ip link set 6in4-tunnel up
    ip addr add $Client_IPv6 dev 6in4-tunnel
    ip route add ::/0 dev 6in4-tunnel
    ip -f inet6 addr
else
    exit 1
fi

sleep 3

if [ -z $(cat /proc/net/dev | awk '{i++;if(i>2)print $1}' | sed 's/[:]*$//g' | grep '6in4-tunnel') ];then
    exit 1
fi

if (! $(curl -fs http://edge.microsoft.com/captiveportal/generate_204 --interface 6in4-tunnel --max-time 10 --retry 2))
then
    exit 1
fi

sysctl net.ipv6.ip_nonlocal_bind=1
ip route add local $Client_IPv6 dev lo
/vproxy run -i $Client_IPv6 $proxy_protocol