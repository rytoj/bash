alias versija='uname -a'
PATH=$HOME/bin/radija_bash:$PATH

alias ls='ls -hAFG --color=auto'

# Teminalas su github
#PS1="\[\e]0;\w\a\]\n\[\e[00;33m\][\d \A \[\e[01;35m\]\w\[\e[00;33m\]]\[\e[0m\]$(__git_ps1 " \[\033[1;32m\](%s)\[\033[0m\]")\n\$ "

PS1="\[\033[01;37m\]\$? \$(if [[ \$? == 0 ]]; then echo \"\[\033[01;32m\]\342\234\223\"; else echo \"\[\033[01;31m\]\342\234\227\"; fi) $(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo '\[\033[01;32m\]sup'; fi)\[\033[01;34m\] \wFV \$\[\033[00m\] "




