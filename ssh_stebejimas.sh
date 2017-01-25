#!/bin/bash
# Stebi logus ir tikrina, kas jungiasi prie serverio

#spalvos
#bash colors
bold=$(tput bold)
yellow=$(tput setaf 3)
green=$(tput setaf 2)
gray=$(tput setaf 0)
red=$(tput setaf 1)
white=$(tput setaf 7)
light=$(tput bold)
reset=$(tput sgr0) #No Color. Turn off all atributes


refresh=2
num=3 #Kiek rodys irasu
path="/var/log/auth.log"
#Renkam tik IP
#grep -Eoa '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'  /var/log/auth.log | tail -f


while true;
do
#Last logins and disconets
last_logins=`grep -Ea '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'  $path |  grep Accepted | tail -n $num`
last_disconnects=`grep -Ea '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'  $path |  grep disconnect | tail -n $num`
last_sudo=`grep -Ea "COMMAND" $path | tail -n $num`

clear
printf "${yellow}Last logins:\n${reset}$last_logins \n"
printf "${green}Last discconets:\n${reset}$last_disconnects \n"
printf "${red}Last sudo:${reset}\n$last_sudo \n"
sleep $refresh
done
