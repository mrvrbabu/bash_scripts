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

yum -y  install bind bind-utils 


sed -i "s/localhost/any/g" /etc/named.conf

sed  -i 's/127.0.0.1/'$IPADDR'/g' /etc/named.conf

echo "include \"/etc/named.homeoffice.net.zone\";" >> /etc/named.conf

cat << EOF > /etc/named.homeoffice.net.zone 
zone "homeoffice.net" IN {
	type master;
	file "homeoffice.net.forward";
	allow-update { none; };
};

zone "2.168.192.in-addr.arpa" IN {
	type master;
	file "homeoffice.net.reverse";
	allow-update { none; };
};
EOF

cat << EOF > /var/named/homeoffice.net.forward 
\$TTL 1D
\$ORIGIN homeoffice.net.
@	IN SOA	@ homeoffice.net. (
					2016082703	; serial
					1D	; refresh
					1H	; retry
					1W	; expire
					3H )	; minimum
	     IN NS masterserver.homeoffice.net.
	     IN NS slavedns001.homeoffice.net.	
masterserver IN A      192.168.2.10
slavedns001  IN A      192.168.2.14
masterserver IN TXT    "DNS master for homeoffice.net"
webserver001 IN A      192.168.2.11	
mail         IN A      192.168.2.12
web          IN CNAME webserver001
www          IN TXT "Webserver: Main webserver for this domain"
homeoffice.net IN MX 3 mail.homeoffice.net 
ns1          IN CNAME masterserver.homeoffice.net.
ns2          IN CNAME slavedns001.homeoffice.net.
slavedns001  IN TXT    "Secondary dns for homeoffice.net" 
EOF


cat << EOF > /var/named/homeoffice.net.reverse
\$TTL 1D
\$ORIGIN 2.168.192.in-addr.arpa.
@	IN SOA	@ homeoffice.net. (
					2016082703	; serial
					1D	; refresh
					1H	; retry
					1W	; expire
					3H )	; minimum
	IN NS   masterserver.homeoffice.net.
	IN NS   slavedns001.homeoffice.net. 
10	PTR	masterserver.homeoffice.net.
11      PTR     webserver001.homeoffice.net. 
12      PTR     mail.homeoffice.net.
14      PTR     slavedns001.homeoffice.net.
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

dig @$IPADDR webserver001.homeoffice.net 
dig @$IPADDR masterserver.homeoffice.net 
dig @$IPADDR -t MX homeoffice.net  
dig @$IPADDR -t TXT www.homeoffice.net  
dig -x 192.168.2.12
dig -x 192.168.2.11
dig axfr homeoffice.net @$IPADDR

echo "Please disable/allow IPTABLES if required to be allowd from other clients"
cd /etc/
echo 
echo "#################Generating dnssec secret key for TSIG transactions##################"
echo "This may take more than a minute" 
echo 
dnssec-keygen -a HMAC-MD5 -b 128 -n HOST master-slave.homeoffice.net
TSIG_KEY=$(cat /etc/K*.key | awk ' { print $7 } ')
cat << EOF > /etc/named.transfer.conf
key master-slave.homeoffice.net. {
  algorithm hmac-md5;
  secret "$TSIG_KEY";
};
EOF 

echo "include \"/etc/named.transfer.conf\";" >> /etc/named.conf 
#EnD 

