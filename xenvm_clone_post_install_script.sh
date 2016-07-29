#!/bin/bash

# Author  : Rbabu 
# Date    : July 2016 
# Purpose : To configure the vm created using ready made template to necessarey configurations like hostname, network, packages, etc


while getopts ':h:m:' option 
do
	case $option in
		h)MYHOSTNAME=$OPTARG;;
		m)MAC=$OPTARG;;
		*)echo 
		  echo "Incorrect switch, Please try executing as sh $0 -h hostname -m macaddress"
		  echo "Hostname : $MYHOSTNAME Macaddress : $MAC" 
		  echo 
		  exit;;
	esac 
done
echo 
echo "This script can be used to set the hostname and mac address for VMs created using template in xen servers"
echo 
echo "Hostname : $MYHOSTNAME Macaddress : $MAC" 
echo
#echo "To configure the vm created using ready made template to necessarey configurations like hostname, network, packages, etc"
#if [ "${HOSTNAME}" == ""  ]
#then
#	echo "Please enter the hostname"
#	break
#else 
       #	echo "$HOSTNAME"
#fi

#if [ "${MAC}" == "" ]
#then
#	echo "Please enter the mac address" 
#	break
#else 
      #	echo "$MAC"
#fi
echo "Present hostname is $HOSTNAME" 
echo 
sleep 2
echo "Desired hostname is $MYHOSTNAME"
sleep 2
echo
echo "##############Resetting host name from localhost.localdomain to $MYHOSTNAME####################"
sleep 2
echo 
sed -i "/^HOSTNAME=/c\HOSTNAME="$MYHOSTNAME"" /etc/sysconfig/network 
cat /etc/sysconfig/network
hostname $MYHOSTNAME 
echo 
echo "Host name reset from localhost.localdomain to $MYHOSTNAME"
echo
hostname
echo
sleep 2
echo "###################Resetting Mac address#######################" 
echo
echo "Present MAC address is : $(grep -i 'HWADDR' /etc/sysconfig/network-scripts/ifcfg-eth0)" 
echo 
sleep 2
echo "Setting new MAC address $MAC"
cp -rf /etc/sysconfig/network-scripts/ifcfg-eth0 /root/ifcfg-eth0.original
sed -i "/^HWADDR=/c\HWADDR="$MAC"" /etc/sysconfig/network-scripts/ifcfg-eth0 
sleep 2
echo 
echo "New MAC address set : $(grep -i 'HWADDR' /etc/sysconfig/network-scripts/ifcfg-eth0)" 
echo 
echo "Restarting network service"
echo 
/etc/init.d/network restart
echo
ifconfig eth0  
IPADDR=$(ifconfig eth0 | grep 'inet addr' | awk ' { print $2 } ' | cut -d : -f 2) && echo "$IPADDR $HOSTNAME" >> /etc/hosts && cat /etc/hosts

#EnD 
