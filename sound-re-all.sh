#!/bin/bash

SINK=`pacmd list-sinks | grep '  index' |  awk -F": " {'print $2'}`
pacmd set-default-sink ${SINK}
pactl list short sink-inputs | awk '{ print $1 }' | while read sound_input
do
    
    pacmd move-sink-input ${sound_input} ${SINK}
done

