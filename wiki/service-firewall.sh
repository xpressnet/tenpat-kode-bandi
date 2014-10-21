#!/bin/sh
# Author	: Bandi Shippuden
# Version	: 21102014.001
#
# SERVICE
#####################################################################
UNB="/usr/sbin/unbound-control" 	# Unbound Control
IPT="/sbin/iptables"				# IPTABLES
EBT="/sbin/ebtables"				# EBTABELES
MDB="/sbin/modprobe"				# MODPROBE
IPS="/sbin/ipset"					# IPSET
#
# INTERFACE
#####################################################################
Local="eth1"
Public="eth0"
#
# KERNEL
#####################################################################
# Modprobe
$MDB xt_TPROXY
$MDB xt_socket
$MDB xt_mark
$MDB nf_nat
$MDB nf_conntrack_ipv4
$MDB nf_conntrack
$MDB nf_defrag_ipv4
$MDB ipt_REDIRECT
$MDB iptable_nat

# Unbound
$UNB start
ip rule add fwmark 1 lookup 100
ip route add local 0.0.0.0/0 dev lo table 100
#
echo 1 > /proc/sys/net/ipv4/ip_forward
echo 0 > /proc/sys/net/ipv4/conf/default/rp_filter
echo 0 > /proc/sys/net/ipv4/conf/lo/rp_filter
echo 0 > /proc/sys/net/ipv4/conf/all/rp_filter
#
# CREAT ADDRESSLIST TO BIPASS
#####################################################################
$IPS create BYPASS hash:net
for ADDR in $(cat /usr/local/bandi-tech/address.txt);
do
$IPS add BYPASS $ADDR
done;
# Port to ACCEPT
$IPS -N port_list_TCP portmap --from 80 --to 8080
$IPS -A port_list_TCP 80
$IPS -A port_list_TCP 443
$IPS -A port_list_TCP 3127
$IPS -A port_list_TCP 3128
$IPS -A port_list_TCP 3129
$IPS -A port_list_TCP 8000
$IPS -A port_list_TCP 8080
# Port HTTP to REDIRECT 3128
$IPS -N port_HTTP portmap --from 80 --to 8080
$IPS -A port_HTTP 80
$IPS -A port_HTTP 8000
$IPS -A port_HTTP 8080
# Port HTTPS to REDIRECT 3129
$IPS -N port_HTTPS portmap --from 443 --to 445
$IPS -A port_HTTPS 443
#
# RESTORE IPTABLES
#####################################################################
$IPT -t mangle -F
$IPT -t mangle -X
$IPT -t mangle -N DIVERT
$IPT -t mangle -A DIVERT -j MARK --set-mark 1
$IPT -t mangle -A DIVERT -j ACCEPT
$IPT -t mangle -A INPUT -j ACCEPT
$IPT -t mangle -A PREROUTING -p tcp -m socket -j DIVERT
$IPT -t mangle -A PREROUTING -m set --match-set BYPASS dst -p tcp -m set --match-set port_common_TCP dst -j ACCEPT
$IPT -t mangle -A PREROUTING -m set ! --match-set BYPASS dst -p tcp -m set --match-set port_HTTP dst -j TPROXY --tproxy-mark 0x1/0x1 --on-port 3128
$IPT -t mangle -A PREROUTING -m set ! --match-set BYPASS dst -p tcp -m set --match-set port_HTTPS dst -j TPROXY --tproxy-mark 0x1/0x1 --on-port 3129
#
# RESTORE EBTABELES
#####################################################################
$EBT -t broute -A BROUTING -i $Local -p ipv4 --ip-proto tcp --ip-dport 80 -j redirect --redirect-target ACCEPT
$EBT -t broute -A BROUTING -i $Local -p ipv4 --ip-proto tcp --ip-dport 443 -j redirect --redirect-target ACCEPT
$EBT -t broute -A BROUTING -i $Local -p ipv4 --ip-proto tcp --ip-dport 8000 -j redirect --redirect-target ACCEPT
$EBT -t broute -A BROUTING -i $Local -p ipv4 --ip-proto tcp --ip-dport 8080 -j redirect --redirect-target ACCEPT
$EBT -t broute -A BROUTING -i $Public -p ipv4 --ip-proto tcp --ip-sport 80 -j redirect --redirect-target ACCEPT
$EBT -t broute -A BROUTING -i $Public -p ipv4 --ip-proto tcp --ip-sport 443 -j redirect --redirect-target ACCEPT
$EBT -t broute -A BROUTING -i $Public -p ipv4 --ip-proto tcp --ip-sport 8000 -j redirect --redirect-target ACCEPT
$EBT -t broute -A BROUTING -i $Public -p ipv4 --ip-proto tcp --ip-sport 8080 -j redirect --redirect-target ACCEPT
#
# BRIDGE CONFIG
#####################################################################
cd /proc/sys/net/bridge/
for i in *
do
echo 0 > $i
done
unset i
cd
echo "Success Creat Proxy Rule"