#!/bin/bash

# Checks all SUID files or programs to see if the're writeble
#tikrina ir direktorijas neiskleidziant turinio ls -ld "$match" 

mtime="7" #How far back (in days) to check for medified cmd.

if [[ "$1" == "-v" ]]; then
	verbose=1
fi


find / -type f -perm -4000 -print0 2>1 | while read -d '' -r match
do
	if [ -x "$match" ]; then #jeigu failas vykdomas
		owner="$(ls -ld $match | awk '{print $3}')"
		perms="$(ls -ld $match | cut -c5-10 | grep w)"
	
		if [ ! -z "$perms"  ]; then
			echo "**** $match (writable and setuid $owner)"
		fi

		if [ ! -z $(find $match -mtime -${mtime}) ]; then
			echo "**** $match (modified within $mtime days and setuid $owner)"
		fi

		if [[ $verbose -eq 1 ]]; then
			#By default only dangerous scripts are listed. If -v, show all.
			ls -ld $match
			
		fi	
	fi
done
exit -1
