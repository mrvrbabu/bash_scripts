#!/bin/bash

# Author 	: RameshBabu
# Date		: Aug 2016
# Purpose 	: To install and configure dhcpd service on target host, example - homeoffice.net network


# install dhcpd and support packages 
echo 
echo "This script will install and configure dhcpd server/service for a network of 192.168.2.0, please modify accordingly as per requirement" 
echo 
sleep 2
ip a
echo 
echo 
read -p "Which is the NIC you would like to bind to dhcp Ex: - eth0, eth1, ens123, ens456, etc : " ethnic
echo 
echo 
printf "Installing dhcpd package"
echo 
sleep 2
yum -y install dhcp

cat << EOF > /etc/dhcp/dhcpd.conf
subnet 192.168.2.0 netmask 255.255.255.0 {
	interface    $ethnic;
	range 	     192.168.2.5 192.168.2.50;
	option routers	192.168.2.10;
	option domain-name "homeoffice.net";
        option domain-name-servers 192.168.2.10;
} 
EOF

echo 
printf "Enabling dhcpd and starting the service on this host\n"
systemctl enable dhcpd
systemctl start dhcpd
systemctl status dhcpd

#EnD
