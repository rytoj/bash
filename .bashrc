# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#sup_edit
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


alias S_sort='ls -trlh $1'
alias py="python3"
alias mount="mount | column -t"
alias S_napp="py Documents/python/Napy/nap.py"
alias S_service_names="lsof -n -P -i +c 13"

#man colors
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;37m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

#automatically correct mistyped directory names on cd 
shopt -s cdspell


#PS1="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\](\$?)\$ "
PS1="\[\033[01;37m\]\$? \$(if [[ \$? == 0 ]]; then echo \"\[\033[01;32m\]\342\234\223\"; else echo \"\[\033[01;31m\]\342\234\227\"; fi) $(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo '\[\033[01;32m\]sup'; fi)\[\033[01;34m\] \w \$\[\033[00m\] "


#finds files in current directory
#eq= find -name "$1"
S_f() {
#   ls | grep "$1"
    find -iname "*$1*"
}


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


S_webmconvert(){
if [ "$#" -lt 2 ] || [ "$1" == "-h"  ]; then
  echo "wembconvert source.mp4 result"
  return 1
else
  avconv -i "$1" -acodec libvorbis -aq 5 -ac 2 -qmax 25 -threads 2 "$2".webm 
fi
}

S_picture() {
	eog "$1"
}


#downloadina nuotraukas is 370chan
S_cenas_pic() {
	curl -s "$1" | grep -Eo "\/b/src/[[:digit:]]*.(png|jpg)" | sed 's/^/http:\/\/370chan.lt/' | sort | uniq | xargs wget -nv
}


#suranda programos pavadinimą
S_findprogramname() {
 read -p "Turn on unknown program and press 'Enter' "
 ps x -o cmd > /tmp/capture1.txt
 read -t 15 -p "Turn off unknown program and press 'Enter'"
 ps x -o cmd > /tmp/capture2.txt
 diff /tmp/capture1.txt /tmp/capture2.txt
}

#timer
S_timer(){
 if [[ "$@" -ne 1 ]]; then
  echo "usage: $FUNCNAME minutes_to_countdown"
  return 1
 fi
 min=$(($1 * 60))
 sleep $min && notify-send "Timer" "$1 min. ended." 
 echo "Timer ended after $1 min."
 }

#opening file with defaul application
teip(){
 xdg-open "$1" &
}


#Stops/Continues espeak
toggle=0
S_espeak_togle() {
	pid=$(pgrep espeak)
	if [ "$toggle" == "0" ]; then
		echo "Stoping espeak (pid:$pid)..."
		kill -STOP $pid
		toggle=1
	else
		echo "Continuing espeak (pid:$pid)"
		kill -CONT $pid
		toggle=0
	fi
}
