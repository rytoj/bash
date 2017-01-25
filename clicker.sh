#!/bin/bash
#Clicker with random interval

ehcohelp() {
 echo "$0" "-f [click count]"
}

if [[ $1 == "-h" ]] || [[ $1 == "--help" ]]; then
  ehcohelp
  exit 1
fi

#Input cheking
if [[ $1 == "-f" ]] && [[ -z $2 ]] ; then
  #validation for no blank number input
  echo "You didn't enter anything. Please enter a number." >&2
  ehcohelp
  exit 1
fi

nodigits=$(echo "$2" | sed  's/[[:digit:]]//g') #123test123 --> test
if [[ $1 == "-f" ]] && [ ! -z $nodigits ]; then
 #if number is entered
  echo "Invalid number format! Only digits, no commas, spaces, etc." >&2
  ehcohelp
  exit 1
fi




TEMPFILE=$(mktemp);
xprop > $TEMPFILE;
xdotool getmouselocation > $TEMPFILE
X=$(awk '{print $1}' $TEMPFILE | grep -o [[:digit:]]*)
Y=$(awk '{print $2}' $TEMPFILE | grep -o [[:digit:]]*)
W=$(awk '{print $4}' $TEMPFILE | grep -o [[:digit:]]*)
genrand(){
  #Generate random integer, for loops
  randsleep=$(( ( RANDOM % 5 )  + 1 )) #RANDOM % 5(range 1-5)
}




if [[ $1 == "-f" ]]; then
  counter=$2
  while [[ $counter -gt 0 ]]; do
    genrand
    xdotool mousemove $X $Y click 1
    ((counter--))
      echo "x:$X y:$Y window:$W sleeptime:$randsleep"
      echo "$counter"
    sleep $randsleep
  done
  exit 0
fi


counter=2
while [[ $counter -gt 0 ]]; do
  #click loop
  genrand
  echo "x:$X y:$Y window:$W sleeptime:$randsleep"
  xdotool mousemove $X $Y click 1&
  sleep $randsleep
  ((counter--))
done


rm -f $TEMPFILE
