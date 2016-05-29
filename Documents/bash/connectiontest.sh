#/!bin/bash

IP="8.8.8.8"
#Time delay in seconds
DELAY="10"
COUNT=
#Number of tests afer error meseage is shown
TEST=1
LOGFILE="/tmp/connectiontest.log"

while :
do
	sleep "$DELAY"
	ping -c 1 "$IP" > /dev/null 2>&1
	if [ "$?" -eq 0 ]; then
		COUNT=0
		 echo "$(date +%F:%T)" UP >> $LOGFILE
	else
		echo "Kazkas netaip"
		COUNT=$(($COUNT + 1))
		if [ "$COUNT" -ge "$TEST" ]; then
			notify-send  "Lost connection: $(($COUNT * $DELAY))s"
		  echo "$(date +%F:%T)" DOWN "$(($COUNT * $DELAY))s" >> $LOGFILE
    fi
	fi
done



