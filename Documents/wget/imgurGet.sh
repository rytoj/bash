#!/bin/bash

#Use q flag for quiet mode, and tell wget to output to stdout with O-
pics=$(wget -O- http://imgur.com/r/gentlemanboners/new/page/1/hit?scrolled | grep image-list-link | cut -d\/ -f4 | cut -d\" -f1 )

while read line
do

wget "http://i.imgur.com/$line.jpg"

done <<< "$pics"

# One liner script
#wget http://imgur.com/r/gentlemanboners/new/page/{0..4}/hit?scrolled -qO -|grep "image-list-link"|cut -d\/ -f4|cut -d\" -f1 |while read line; do wget "http://i.imgur.com/$line.jpg";done
