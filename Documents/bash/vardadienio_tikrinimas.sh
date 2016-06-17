#!/bin/bash

#Tikrina ar šiandien vardadienis

VARDADIENIAI=(01.15 02.06 01.25 06.26 06.29 10.19 06.17)
dabartineDiena=$(date +%m.%d)
export DISPLAY=:0 #Kad veiktu notify-send

for item in ${VARDADIENIAI[*]}; do
        if [ "$item" == "$dabartineDiena" ]; then
                /usr/bin/notify-send PRIMINIMAS "Šiandien Pauliaus vardadienis $
        fi
#       echo "$item" #DEBUG
done

#crontab -e tikrinimas kiekvieną dieną 8,15,22h
#00 8,15,22 * * * /usr/sbin/vardadieniotikr.sh
