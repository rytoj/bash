#!/bin/bash

BASHRC=/etc/bash.bashrc
NANORC=/etc/nanorc

searchterm=color
eilute=24
tmpfile=/tmp/filecontent
NANORCTMP=/tmp/nanorctmp

updatetmp(){
  cat -n $NANORCTMP > $tmpfile
}

grep -q -n "^#.*$searchterm" "$NANORC" #pagal žodi ieškom eilutės

# cat -n $NANORC > $tmpfile #laikinai išsaugom i tmp failą, kad galetume patikrinti ar eiluteje yra #
# cat  $NANORC > $NANORCTMP #originalo kopija

set -x
# grep -E "^([[:space:]]*$eilute[[:space:]])#" $tmpfile # gaudo eilute su vienu #
tikrina_hashtag=$(grep -c -E "^([[:space:]]*$eilute[[:space:]])#" $tmpfile) # gaudo eilutes su -- eilutes numeriu #

if [[ $tikrina_hashtag = 0 ]]; then
   sed -i "$eilute s/^/#/" $NANORCTMP # užkomentuoja eilutę
   updatetmp
else
  sed -i "$eilute s/^#//" $NANORCTMP # atkomentuoja eilutę
  updatetmp
fi

set +x


#TODO
#paprasius grep ismeta eiluciu sarasa su pasirinkimu, ka ankomentuoti
#kazka gero
