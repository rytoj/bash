#!/bin/bash
#This scrip start Appinventor, build server and aiStarter for emulator-phone via USB

menu() {
if [ "$#" -eq 0 ] ; then
cat << EOF >&2
Menu:
 1|a [Starts appinventor + build + emulator]
2 Starts appinventor + build server
 e [Starts emulator]
k  kill all sessions
EOF
fi
}

menu
while read command args
  do
    case $command in
     1|a)
      cd /home/$USER/Documents/appengine-java-sdk/bin && ./dev_appserver.sh --port=8888 --address=0.0.0.0 /home/$USER/Documents/appinventor-sources/appinventor/appengine/build/war &
      cd /home/$USER/Documents/appinventor-sources/appinventor/buildserver && ant RunLocalBuildServer &
      /usr/google/appinventor/commands-for-Appinventor/aiStarter &
    ;;
    e)
      /usr/google/appinventor/commands-for-Appinventor/aiStarter &

     ;;
    *)
     echo "Not and argument"
     ;;
    esac
  done
exit 0






cd /home/$USER/Documents/appengine-java-sdk/bin && ./dev_appserver.sh --port=8888 --address=0.0.0.0 /home/$USER/Documents/appinventor-sources/appinventor/appengine/build/war &
cd /home/$USER/Documents/appinventor-sources/appinventor/buildserver && ant RunLocalBuildServer &
/usr/google/appinventor/commands-for-Appinventor/aiStarter &
