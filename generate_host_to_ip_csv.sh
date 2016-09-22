#!/bin/bash

#: Title        : remove_decomd_hosts_foreman.sh 
#: Date         : Sep 2016
#: Author       : "RameshBabu" 
#: Version      : 1.0
#: Description  : This script will perform a nslook up of hosts and generate a .csv file to be applied for bulk add remove in dns server. 
#: Options      : None 

# Pass a hostslist file with hosts FQDN name 
#example1.homeoffice.net
#example2.homeoffice.net 

printf "\n" 
printf "This script will perform a nslook up of hosts and generate a .csv file to be applied for bulk add remove in dns server. \n" 
printf "\n" 

filename=$1
printf "%s\n" $filename
i=1
while read file
do
  #echo "Line $i : $filename"
  echo "$file"
  host $file >>./nslookup_final_hosts_result.txt 
  dig $file >>./dig_final_hosts_result.txt 
  IPADDR=$(host $file | awk ' { print $4 }') 
  ping -c 1 $file >>./ping_final_hosts_result.txt
  echo "delete, $file., 3600,  A, $IPADDR" >> delete_final_decommissioned_hosts_list.csv  
  echo "add, $file., 3600,  A, $IPADDR" >> add_final_decommissioned_hosts_list.csv  
  ((i++))
done < $1
#EnD
