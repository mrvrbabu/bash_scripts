#!/bin/bash

# Author 	: RameshBabu
# Date		: Aug 2016
# Purpose	: To generate and copy the ssh to remote host for passwordless access. 

echo 
echo "This script will generate and copy the ssh key to remote host for passwordless access" 

cd ~/.ssh
echo $PWD
ssh-keygen -t rsa
read -p "Please enter the remote hosts IP Address : " TARGETNAME  

ssh-copy-id -i id_rsa.pub root@$TARGETNAME
