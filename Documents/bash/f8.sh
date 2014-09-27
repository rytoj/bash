#!/bin/bash

rm index.html

wget http://10minutemail.com/10MinuteMail/index.html

#atidarom laikino el. pašto puslapį

sessid=$(sed -n 's/<form id="j_id4" name="j_id4" method="post" action="\(.*.\)" enctype=".*/\1/p' index.html)

#paimam seanso id

mail=$(sed -n 's/<br\/>\(.*@.*\) is your temporary e-mail address\..*/\1/p' index.html)

#paimam el. pašto adresą

echo $mail | xclip -selection c

#nukopijuojam laikiną el. paštą į iškarpinę

sleep 20

#kad nesimakaluotų po akim dar viena kortelė, bevedant registracijos duomenis, palaukiam 20s tada atidarom laikino el. pašto puslapį

firefox -new-tab http://10minutemail.com/$sessid

#atveriam naršyklę

rm index.html
