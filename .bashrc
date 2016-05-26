#Prideda programą prie PATH
#PATH=$HOME/bin/programos_pavadinimas:$PATH

# Teminalas su github iš zshell
#PS1="\[\e]0;\w\a\]\n\[\e[00;33m\][\d \A \[\e[01;35m\]\w\[\e[00;33m\]]\[\e[0m\]$(__git_ps1 " \[\033[1;32m\](%s)\[\033[0m\]")\n\$ "

#PS1 su $? 
#PS1="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\](\$?)\$ "
PS1="\[\033[01;37m\]\$? \$(if [[ \$? == 0 ]]; then echo \"\[\033[01;32m\]\342\234\223\"; else echo \"\[\033[01;31m\]\342\234\227\"; fi) $(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo '\[\033[01;32m\]sup'; fi)\[\033[01;34m\] \wFV \$\[\033[00m\] "


#randa failus darbiniame kataloge [f pavadinimas]
f() {
# ls | grep "$1"
  find -iname "*$1*"
}



translateToLt() {
  firefox -new-tab -url https://translate.google.com/#en/lt/$1
}

etimologija() {

  firefox -new-tab -url http://etimologija.baltnexus.lt/?w=$1
}

etymology() {
  firefox -new-tab -url http://etymonline.com/index.php?allowed_in_frame=0\&search=$1
}



#Shows man page for command under cursor and lets you continue where you left off when you're done . 
#Useful when you have a long command line and need to quickly look at some man page.
function man_on_word {
	TMP_LN=$READLINE_LINE
	TMP_POS=$READLINE_POINT
	while [ $TMP_POS -gt 0 ] &&
		[ "${TMP_LN:TMP_POS:1}" != " " ]
		do true $((--TMP_POS))
	done
	if [ 0 -ne $TMP_POS ]; then true $((++TMP_POS));fi
	TMP_WORD="${READLINE_LINE:$TMP_POS}"
	TMP_WORD="${TMP_WORD%% *}"
	man "$TMP_WORD"
}
bind -x '"\C-h":man_on_word'

#optionally:
#set -o vi
#bind -m vi-command -x '"K":man_on_word'


#webm convertavimas
webmconvert(){
if [ "$#" -lt 2 ] || [ "$1" == "-h"  ]; then
  echo "wembconvert source.mp4 result"
  return 1
else
  avconv -i "$1" -acodec libvorbis -aq 5 -ac 2 -qmax 25 -threads 2 "$2".webm
fi
}
