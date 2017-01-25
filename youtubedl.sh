#!/bin/bash

link=$(xsel -o)
savedir="/tmp/"

download() {
  if [[ $? == 0 ]]; then
     youtube-dl --extract-audio --audio-format mp3 "$link" --output "/${savedir}/%(title)s.%(ext)s"  && notify-send "Saved to $savedir" || echo "Interupted"
  else
    echo "Canceled"
fi

}



if zenity --entry \
	--title="Youtube download" \
	--text="Enter Youtube link:" \
	--entry-text ${link:="empty selection"}
    download
  then echo $?
else echo "No link entered" && notify-send "Please enter correct url"
fi
