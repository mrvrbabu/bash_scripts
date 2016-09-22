#!/bin/bash

# Author 	: RameshBabu 
# Date		: Sep 2016 
# Purpose	: Add or delete users  
# Description   : To add or delete users which will demostrage functions, for and if loop 
# Version 	: 1.0


function adduser() {
	useradd $k
}

function deluser() {
	userdel -r $j
}

# Create a with 100 users as user1, user2, user3....
for i in `seq 1 100`; do echo user$i; done > users.txt

USERSFILE="/home/rbabu/bash_scripts/users.txt"
echo 
printf "Please select if you want to add or delete the users, type 'add' or 'delete' : " 
read answer 

if [ $answer == delete ]
then
	printf "Deleting users 1-100\n"
        sleep 3
	for j in `cat $USERSFILE`
		do
			deluser $j
		done
	printf "Users user1-user100 deleted\n"
elif [ $answer == add ] 
then 
	printf "Adding users 1-100\n" 
        sleep 3
	for k in `cat $USERSFILE`
		do
		       adduser $k
		done
	printf "Users user1-user100 added\n"
else 
        printf "\n"
	printf "Invalid input answer $answer please type 'add' or 'delete'\n" 

fi
printf "\n"
tail -n 10 /etc/passwd

#EnD 
