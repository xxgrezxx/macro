#! /bin/bash

function command()
{
	case $input in
		"1")
			icmd="-sn "
			;;
		"2")	
			icmd="-sn --traceroute "
			;;
		"3")
			icmd="-sT -sV -T4 "
			;; 
		"4")
			icmd="-T4 -O -sC "
			;;
		"5") 
			icmd="-T4 -sT -sV -sC -A "
			;;
		*)
			echo "invalid command, returning to main page"
			main
			exit
			;;	
	esac
}

function main()

{
	echo "Select the types of scan [ Ping Sweep ]"
	printf "1:Ping sweep \n2:Traceroute \n3:TCP Port Scan \n4:OS/scripts scan \n5:Intense Scan \n\n"
	read input
	if [ -z $input ]
	then
		input="1"
	fi
	command
	read -p "Enter target ip address to scan: "  IP
	while [ -z $IP ] 
	do 
		read -p "Invalid address, please enter again [aaa.bbb.ccc] : " IP
	done
	

	
	printf "Opening Nmap, preparing to scan..."

	nmap $icmd $IP
}


clear
echo " _   _                         ____  _                 _ _  __ _          _ "
echo "| \ | |_ __ ___   __ _ _ __   / ___|(_)_ __ ___  _ __ | (_)/ _(_) ___  __| | "
echo "|  \| | '_ ' _ \ / _' | '_ \  \___ \| | '_ ' _ \| '_ \| | | |_| |/ _ \/ _' | "
echo "| |\  | | | | | | (_| | |_) |  ___) | | | | | | | |_) | | |  _| |  __/ (_| | "
echo "|_| \_|_| |_| |_|\__,_| .__/  |____/|_|_| |_| |_| .__/|_|_|_| |_|\___|\__,_| "
echo "                      |_|                       |_|                         "

printf "\n\n"
sleep 0.5s

main

