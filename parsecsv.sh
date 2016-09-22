#!/bin/bash 

# pass a file with contents as below. 

#hammer,55,4
#drill,43,5
#screwdriver,34,9
#rockdrill,23,6
#knife,52,8


OLDIFS=$IFS
IFS=","

while read product price quantity 
do 
	echo -e "\e[1;31m$product  
	========================\e[0m\n\
	Price : \t $price \n\
	Quantity : \t $quantity \n"

done < $1
IFS=$OLDIFS
