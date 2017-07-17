#! /bin/bash
## firstboot script to render /etc/network/interfaces
## useful if you have a list of MAC addresses

set -e
set -x

declare -A IPADDRS
IPADDRS=( ['52:54:00:67:58:89']='ubu0 192.168.125.120'
          ['52:54:00:72:e3:a2']='ubu1 192.168.125.121'
          ['52:54:00:d9:b8:f0']='ubu2 192.168.125.122'
	  ['52:54:00:9d:ba:db']='ubu3 192.168.125.123' )


MYMAC=$(cat /sys/class/net/ens3/address)

declare -a MYDATA
MYDATA=(${IPADDRS[$MYMAC]})

echo ${MYDATA[0]} > /etc/hostname

rm -f /etc/network/interfaces.d/*.cfg

cat > /etc/network/interfaces.d/ubuntu.cfg <<EOF
auto lo
iface lo inet loopback

auto ens3
iface ens3 inet static
    address  ${MYDATA[1]}
    netmask 255.255.255.0
    network 192.168.125.0
    broadcast 192.168.125.255
    gateway 192.168.125.1
    dns-nameservers 192.168.125.1
EOF


systemctl restart networking.service
