#! /bin/bash

echo "//////////////////////////////////////////////////////"
echo "		  Eternalblue[MS17_010] Scanner"
echo "//////////////////////////////////////////////////////"

printf "This is a simple program that creates a resource file that can be used upon starting up with msfconsole"
printf "\n\n\n"

read -p "Please enter the target host IP address: " target
while [ -z $target ]
do
	read -f "Error, please enter the target's IP address" target
done

printf "Preparing to generate the resource file...\n"


#wipe clean if exist
if [ -f ebs.rc ]
then
	> ebs.rc
	
fi

#commands in the resource file
echo use auxiliary/scanner/smb/smb_ms17_010 >> ebs.rc
echo set rhosts $target >> ebs.rc
echo run >> ebs.rc


sleep 0.5s
read -p "Resource file generated, would you want to run the handler on a new terminal?[y/n] " ebs
if [ $ebs = "y" ] || [ $ebs = "Y" ]
then
	printf "running eternalblue scan on new terminal...\n\n"
	gnome-terminal -- msfconsole -r ebs.rc
fi

printf "exiting....\n\n"

