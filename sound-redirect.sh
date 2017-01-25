#!/bin/bash
SINK=`pacmd list-sinks | grep '  index' |  awk -F": " {'print $2'}`
pacmd set-default-sink ${SINK}
echo "Devices:"
pacmd list-sinks | egrep 'index|active port' #Rodo visus audio irenginius
echo "* - Active device"
echo
echo "Audio streams:"
pacmd list-sink-inputs | egrep "client:|index" #Rodo visas programas kurios groja
read -e -p "Enter index, for redirection: " sound_index
pacmd move-sink-input ${sound_index} ${SINK}
