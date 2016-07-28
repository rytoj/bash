#!/bin/bash
LOCATIONS=("54.68598,25.28608" "54.68864,25.29037" "54.68907,25.27124", "54.68469,25.26924", "54.68343,25.29756", "54.68527,25.28870")
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" #Working directory
SLEEPTIME=$(( $RANDOM % 100 + 400 )) # sleeptime generates from range 400-499
FILE="$DIR/pokecli.py"
CONF="$DIR/config.json"

arraylen=$((${#LOCATIONS[@]} - 1))
counter=0 # for counting crash cycles
array_el=0

#trap for while exit with Ctrl+c
trap "echo; echo Exiting script "$0";exit 2" SIGINT


echo "Starting $FILE " 2>&1

function start_script(){
  #Get location from aray
  if [[ "$array_el" > "$arraylen" ]]; then
    echo "Array ended. Reseting..." 2>&1
    array_el=0
  else
    location='"location": "'"${LOCATIONS[$array_el]}"'",'
    sed -i 's/"location".*/'"$location"'/' $CONF
    echo "Current location:" $location  2>&1
    echo "Array element" $array_el 2>&1
    sleep 1
    array_el=$((array_el + 1))
  fi

  python $FILE
}

#main loop
while true; do
  start_script
  if [[ "$?" == 1 ]]; then
    echo "Sleeping $SLEEPTIME seconds" 2>&1 
    sleep $SLEEPTIME
    start_script
    counter=$((counter + 1))
    trap "echo Script restarted: $counter time\(s\), ended with $array_el array element" EXIT # Message after exit
  fi
done
