#!/bin/bash

# Author 	: RameshBabu
# Date   	: Sep 2016
# Purpose       : To install and configure dns, dhcp and pxe server usinng dnsmasq, dhcp, pxe, vsftpd

echo 
echo "This script will install and configure the target server with dns, dhcp, pxe server configurations" 
echo 
sleep 2

if [ -d /var/ftp/pub/centos7 ]
then
echo "/var/ftp/pub/centos7 ready, Continuing....."
else 
echo  "/var/ftp/pub/centos7 OS image directory does not exist, please create /var/ftp/pub/centos7 and copy the OS files from ISO before proceeding, Qutting"
fi


echo "Please verify that you have perfomed the prep work by downloading the required iso and copied the contents to /var/ftp/pub" 

yum -y install bind-utils dnsmasq
mv -v /etc/dnsmasq.conf /etc/dnsmasq.conf-$(date +"%d-%m-%Y").backup 
echo 
ip a 
read -p "Please enter the ethernet on which the dns server will be listening on : " ETH 
echo 
read -p "Please enter the ip address the server will be listening on : " IPADDR

# Install and configure dnsmasq 

cat << EOF > /etc/dnsmasq.conf 
#Domain name 
domain="homeoffice.net"
#Dhcp network range, subnet mask and default lease time - 1 hour
dhcp-range=192.168.2.5,192.168.2.200,255.255.255.0,1h
#Default router
dhcp-option=3,192.168.2.10
#Default DNS 
dhcp-option=6,192.168.2.10
#Network broadcast 
dhcp-option=28,192.168.2.255
#Dhcp pxe boot menu options
pxe-prompt="Press F8 for menu.", 15 
pxe-service=x86PC, "Boot to Local Hard Disk"
pxe-service=x86PC, "Install CentOS 7", pxelinux
enable-tftp
tftp-root=/var/lib/tftpboot
EOF

# Install pxelinux bootloader provider package syslinux 

yum install syslinux -y 
echo 
echo "Creating the required directories and copying the bootloader and menu files"  

mkdir -pv /var/lib/tftpboot/centos7 
cp -v /usr/share/syslinux/pxelinux.0 /var/lib/tftpboot
cp -v /usr/share/syslinux/menu.c32 /var/lib/tftpboot
mkdir -pv /var/lib/tftpboot/pxelinux.cfg
chmod -v 755 /var/lib/tftpboot/pxelinux.0

#Creating default menu 
cat << EOF2 > /var/lib/tftpboot/pxelinux.cfg/default
default menu.c32
	prompt 0
	menu title ####### Installs R Us ###########
	label centos7
	menu label Install Centos 7
 	kernel centos7/vmlinuz
        append initrd=centos7/initrd.img method=ftp://$IPADDR/pub/centos7
EOF2

yum -y install tree 
cd /var/lib/tftpboot && tree . 
echo 
yum -y install vsftpd
mkdir -pv -m 755 /var/ftp/pub/centos7
cp -v /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf-$(date +"%d-%m-%Y").backup
cat << EOF3 > /etc/vsftpd/vsftpd.conf
listen=YES
local_enable=NO
anonymous_enable=YES
write_enable=NO
anon_root=/var/ftp
EOF3

echo 
echo "Copying vmlinux kernel and initrd to tftpboot directory" 

cp -v /var/ftp/pub/centos7/isolinux/vmlinuz /var/lib/tftpboot/centos7/
cp -v /var/ftp/pub/centos7/isolinux/initrd.img /var/lib/tftpboot/centos7/

systemctl enable vsftpd 
systemctl start vsftpd
systemctl status vsftpd 
echo 
sleep 2

#systemctl enable dhcp 
#systemctl status dhcp 
echo 
sleep 2 
systemctl enable dnsmasq  
systemctl start dnsmasq  
systemctl status dnsmasq  

netstat -ntlp
netstat -nulp 
echo 
echo "########### DNS, DHCP, TFTP, PXE servers configured successfully, please try pxe installation #############" 
echo 
