#!/bin/bash


#Author 	: RameshBabu
#Date		: Aug 2016
#Purpose	: To install and configure bind dns server on RHEL/CentOS7

echo
echo
echo "To install and configure bind dns server on RHEL/CentOS7"
echo 

ip a 
echo 
read -p "Please enter the ip address dns will listen to : " IPADDR

read -p "Please enter the IP Address of the master dns server : " MASTERS
yum -y  install bind bind-utils 


sed -i "s/localhost/any/g" /etc/named.conf

sed  -i 's/127.0.0.1/'$IPADDR'/g' /etc/named.conf

echo "include \"/etc/named.homeoffice.net.zone\";" >> /etc/named.conf

cat << EOF > /etc/named.homeoffice.net.zone 
zone "homeoffice.net" IN {
	type slave;
	file "slaves/homeoffice.net.forward";
	masters { $MASTERS; };
};

zone "2.168.192.in-addr.arpa" IN {
	type slave;
	file "slaves/homeoffice.net.reverse";
	masters { $MASTERS; };
};
EOF
netstat -nulp | grep :53
sleep 3
systemctl status named  
systemctl start named 
systemctl enable named 
systemctl status named  
sleep 3
netstat -nulp | grep :53
echo "search homeoffice.net" > /etc/resolv.conf
echo "nameserver $IPADDR" >> /etc/resolv.conf

rndc reload 

dig @$IPADDR webserver001.homeoffice.net 
dig @$IPADDR masterserver.homeoffice.net 
dig @$IPADDR -t MX homeoffice.net  
dig @$IPADDR -t TXT www.homeoffice.net  
dig -x 192.168.2.12
dig -x 192.168.2.11
dig axfr homeoffice.net @$IPADDR
dig -t NS homeoffice.net $IPADDR

echo "Please disable/allow IPTABLES if required to be allowd from other clients"
#EnD 

