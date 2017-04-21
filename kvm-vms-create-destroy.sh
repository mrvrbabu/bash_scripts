#!/bin/bash 


#: Title	: kvm-vms-create-destroy.sh 
#: Date 	: 21 April 2017
#: Author	: Ramesh Babu
#: Version	: 0.1
#: Purpose	: To create or destroy vms in kvm hypervisor
#: Description  : This script will create (clone) or destroy vms on kvm hypervisor based on users inputs to save time 


printf "\n"
printf "This script will create or destroy the vms on kvm hosts. Pass the fqdns or domain(U) names from file as input\n" 
printf "\n" 
filename=$1
# Highlighting hostname in colors
filename=$1
flashredblink='\033[5;31m'
flashred='\033[31m'
nocolor='\033[0m'


# Vm create function
function create {
	i=1
while read file
do
	echo -e "Creating(cloning) vm $flashredblink"$file"$nocolor"
	#Vm clone command
	#virt-clone --connect qemu:///system --original centosminimaltemplate.homeoffice.net --name $file --file /var/lib/libvirt/images/$file.qcow2
	virt-clone --connect qemu:///system --original bridgedcentos.homeoffice.net --name $file --file /var/lib/libvirt/images/$file.qcow2    # Original Vm template "bridgedcentos.homeoffice.net" to be cloned from
	sleep 2
	virsh start $file
	((i++))
	done < $filename 
	echo ""
	virsh list --all | grep -i running 
}


# VM destroy function 
function destroy {
	j=1
	virsh list --all | grep -i running 
	while read file
	do
		echo "" 
		echo -e $flashred"About to destroy vm$nocolor $flashredblink$file$nocolor" 
		virsh destroy --domain $file
		sleep 5 
		virsh undefine --domain $file
		rm -vrf /var/lib/libvirt/images/$file.qcow2
	((j++))
	done < $filename 
	echo ""
}

#Create/Destroy selection
read -p "Please enter if you want to create or destroy the domUs, [Create/Destroy] : " answer
echo $answer
echo 
if [[ -n $answer ]] && [[ "create" == "$answer" ]] || [[ "Create" == "$answer" ]]
then
	#read -p "Please enter the file name which contains the fqdns of the vms to be created, one fqdn perline Ex:- manager1.homeoffice.net, worker1.homeoffice.net : " filename
	echo "About to create below instance[s] as per your choice"
	echo ""
	cat $filename
	echo ""
	create $filename					# Calling function create
else
	#read -p "Please enter the file name which contains the fqdns of the vms to be created, one fqdn perline Ex:- manager1.homeoffice.net, worker1.homeoffice.net : " filename
	echo "About to destroy below instance[s] as per your choice"
	echo ""
	cat $filename
	echo "" 
	destroy $filename					# Calling function destroy
fi
	 

#EnD
