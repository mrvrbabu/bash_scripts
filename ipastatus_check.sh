#!/bin/bash

# Author  : Rbabu 
# Date    : July 2016
# Purpose : FreeIPA Directory Service status check RUNNING/STOPPED and start if down


#Get the service status 
status=$(/usr/sbin/ipactl status 2> /root/ipastatus_check.log | awk ' { print $3 } ')
for ipastatus in $status
do
if [ $ipastatus == "STOPPED" ] || [ $ipastatus == "stopped" ]     #Check if the service is STOPPED 
then
	echo ""
	echo "Directory Server is STOPPED, starting......may take about 30 secs to start"  
	echo ""
	/usr/sbin/ipactl start                                             #Start if the service is stopped 
	echo ""
        echo "ipa service is now RUNNING"
        netstat -ntlp | grep :389
        netstat -nltp | grep :636
        echo ""

else 
	echo ""
	echo "ipa service is running"
	netstat -ntlp | grep :389
	netstat -nltp | grep :636
	echo ""
        break
fi
done

#EnD 

