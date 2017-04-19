#!/bin/bin

# Colors 
printf "\n"
printf "colors\n"
flashred='\033[5;31m'           # Assign variables to colors for substitution
none='\033[0m'
echo -e '\033[1;31mERROR: \033[5;31mSomething went wrong.\033[0m'

printf "\n"
printf "helpers\n"
today=$(date +"%d-%m-%Y")
time=$(date +"%H:%M:%S")
printf "Today's date:\t%s\nToday's time:\t%s\n"  $today $time


printf "\n"
printf "Arrays\n"
printf "\n"
a=()				 # Initilize empty array a
b=("apple" "banana" "cherry")
echo ${b[@]}                     # Print entire array
echo ${b[2]}    		 # Print third element of array, starts with 0 
echo ${b[@]: -1}                 # Print last element of array
b[3]="mango"
echo ${b[@]: -1}                 # Print last element of array
b+=("pineapple")
echo ${b[@]: -1}                 # Print last element of array

# Associated Arrays 
printf "\n"
printf "Associated Arrays" 

declare -A myarray
myarray[color]=blue
myarray["office building"]="HQ West"

echo ${myarray["office building"]} is ${myarray[color]}    
printf "\n"

echo -e $flashred"Dealing with files\n" $none

echo "some text" > file.txt
echo "Some more test" >> file.txt

#i=1
while read f; do               # Reads the file file.txt line by line into the variable 'f'
	echo $f
#	echo "Line $1: $f"
#	((i++))
done < file.txt
rm  file.txt 
printf "\n"
echo -e $flashred"The 'here' document '<<' \n" $none
logfile="$today"_report.log
#cat << EOF > $logfile         # Redirect the contents to target file
cat << EOF 
This is end
This is also ERROR:{B1}
This is also an error:
This is end
This is also ERROR:{B1}
This is also an error:
EOF
printf "\n"


echo -e $flashred"The control structures and if statement\n" $none
printf "Enter some number between 0-9\n" 
read a
if [ $a -gt 4 ]
then
	echo "$a is greater than 4"
	echo 
else
	echo "$a is not greater than 4"
	echo
#elif [ $a -eq 4 ]
#then
#	echo $a is equal to 4
#	echo
#fi
fi


c="This is4444 my string"
if [[ $c =~ [0-9]+ ]]
then 
	echo "There are numbers in the string: $c"
else 
	echo "There are no numbers in the string: $c"
fi

echo -e $flashred"The control structures the while,until statements\n" $none

j=0
while [ $j -le 10 ]; do
	echo $j
	((j+=1))
done

echo ""
echo "Until loop" 

k=0
until [ $k -ge 10 ]; do
	echo $k
	((k+=1))
done 

echo 
echo -e $flashred"The control structures 'For Loop'\n" $none

#for i in {1..100} 
for i in {1..3} 
do
	echo $i
done
	
echo 

for ((i=22; i<=28; i++))
do
	echo $i
done

fruitarray=("apple" "orange" "banana" "pinaple")
for i in ${fruitarray[@]}
do
	echo $i 
done

echo 
echo -e $flashred"The control structures 'For Case'\n" $none

printf "Enter the name of animal, Ex:- dog, cat, etc\n" 
printf "Animal:\t%s"; read animal

case $animal in 
	cat) echo "Feline";;
	dog) echo "Canine";;
	  *) echo "Nothing to match";;
esac



echo -e $flashred"The control structures 'Funtions'\n" $none

function greeting {
	echo "Hi there"
}

greeting
function greeting {
	echo "Hi $1 $2"
}

greeting Scott
greeting Ramesh

greeting Ram Babu 



function numberthings {
	m=1
	for m in $@; do
		echo $m: $f
		((m+=1))
	done
}
numberthings $(ls /var/log/sa)

