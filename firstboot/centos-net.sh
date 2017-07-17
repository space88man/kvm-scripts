#! /bin/bash
## firstboot script to render /etc/sysconfig/network-scripts/ifcfg-eth0
## useful if you have a list of MAC addresses

set -e
set -x

declare -A IPADDRS
IPADDRS=( ['52:54:00:21:ec:cc']='kube0 192.168.125.100'
          ['52:54:00:38:f3:f9']='kube1 192.168.125.101'
          ['52:54:00:e3:f7:a8']='kube2 192.168.125.102'
          ['52:54:00:d0:fc:a6']='kube3 192.168.125.103' )

MYMAC=$(cat /sys/class/net/eth0/address)

declare -a MYDATA
MYDATA=(${IPADDRS[$MYMAC]})

echo ${MYDATA[0]} > /etc/hostname

cat > /etc/sysconfig/network-scripts/ifcfg-eth0 <<EOF
DEVICE="eth0"
BOOTPROTO="none"
ONBOOT="yes"
TYPE="Ethernet"
USERCTL="yes"
PEERDNS="yes"
IPV6INIT="no"
IPADDR=${MYDATA[1]}
PREFIX=24
DNS1=192.168.125.1
GATEWAY=192.168.125.1
EOF


systemctl restart network.service
