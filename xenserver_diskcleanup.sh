#!/bin/bash

# Author 	: Rbabu
# Date		: July 2016
# Purpose	: To clean up disk space on xen servers (House keeping of disk)
# Note          : Run this script on any of the xen servers to clean up the disk space or schedule it as a cron to perform autoclean up

BEFORE_CLEANUP=$(df -h /) 
cd /opt/splunkforwarder/var/log/splunk
#echo $(pwd)


echo ""
echo "Removing old splunkd.logs from /opt/splunkforwarder/var/log/splunk"
sleep 1; echo 1.
sleep 1; echo 2..
sleep 1; echo 3...
rm -vrf splunkd.log.*


echo ""
echo "Removing old metrics.logs from /opt/splunkforwarder/var/log/splunk"
sleep 1; echo 1.
sleep 1; echo 2..
sleep 1; echo 3...
rm -vrf metrics.log.* 

cd /var/log 
#echo $(pwd)
echo ""
echo "Removing old xensource.logs and xenstored-access.logs from /var/log/"
sleep 1; echo 1.
sleep 1; echo 2..
sleep 1; echo 3...

rm -vrf xensource.log.*.gz
rm -vrf xenstored-access.log.*.gz

echo "#######################Disk space before cleanup#######################" 
echo "$BEFORE_CLEANUP"
AFTER_CLEANUP=$(df -h /)

echo ""
echo ""
echo "######################Current usage after cleanup#####################"
echo  "$AFTER_CLEANUP"
echo ""

#End 

