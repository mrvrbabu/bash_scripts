#!/bin/bash

# Author 	: RameshBabu
# Date		: Aug 2016
# Purpose	: To configure linux box as router for RHE/Centos - 7

echo 
echo "To configure a linux box as router on RHEL/CentOS-7"
echo 
ip a | grep enp  
ip a | grep eth  
echo
sleep 3 
read -p "Please select the Ethernet nic for outboud traffic i.e to allow outside world access ex:- eth0, eth1, enp123, enp456 : " ethnic0
echo 
read -p  "Please select the Ethernet nic for inbound traffic i.e the LAN to allow outside world access ex:- eth0, eth1, enp123, enp456 : " ethnic1
echo $ethnic0
echo $ethnic1

yum install iptables-services iptables-utils -y  
systemctl stop firewalld
systemctl disable firewalld
yum remove firewalld -y 
systemctl enable iptables
systemctl start iptables  
cat /etc/sysconfig/iptables
iptables -t nat -nvL
echo 
iptables -t nat -A POSTROUTING -o $ethnic0 -j MASQUERADE
iptables -t nat -nvL
echo "Saving iptables entries"
iptables-save
iptables-save > /etc/sysconfig/iptables

sed -i.bak "/INPUT -j REJECT --reject-with icmp-host-prohibited/ a -A FORWARD -i "$ethnic0" -o "$ethnic1" -m state --state RELATED,ESTABLISHED -j ACCEPT" /etc/sysconfig/iptables 
sed "/RELATED,ESTABLISHED/ a -A FORWARD -i "$ethnic1" -o "$ethnic0" -j ACCEPT" /etc/sysconfig/iptables 
systemctl restart iptables 

echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.d/99-sysctl.conf 

sysctl -p 

echo "Done"

#EnD
