#!/bin/bash
#This script checks if file is updated and sends file to remote host

if [[ "$#" -ne 2 ]] ; then
    echo "usage: $0 filename user@host:/folder/"
    echo "usage: $0 filename /tmp/"
    exit 0
fi


filename="$1"

m1=$(md5sum "$filename")

while true; do

  # md5sum is computationally expensive, so check only once every 10 seconds
  sleep 5

  m2=$(md5sum "$filename")

  if [ "$m1" != "$m2" ] ; then
    echo "$1 file has changed! `date +%F:%T`"
    echo "Sendinding file.."
    cmd=$(echo "$2" | grep -o "@")
    if [[ -z cmd ]]; then
      cp "$1" "$2"
    else
      scp "$1" "$2"
    fi

    m1=$m2
  fi
done
