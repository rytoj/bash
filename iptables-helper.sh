#!/bin/bash
# iptables - usefull rules and more


printf "1. IP praleidimas"
printf "2. ssh praleidimas"
printf "3. http ir https praleidimas:"
printf "4. blokavimas per pietų pertrauką:"
printf "5. minimali ddos apsauga:"
printf "6. Praleidziam localhost:"


myip=`echo ${SSH_CONNECTION} | awk '{print $1}'`
read
case "$REPLY" in
        1)
             iptables -I INPUT -s "$myip" -j ACCEPT
            ;;

        2)
            iptables -I INPUT -s "$myip" -p tcp --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
            ;;

        3)
            iptables -I INPUT -p tcp -m multiport --dports 80,443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
            ;;

        4)
            iptables -A INPUT -p tcp -m time --timestamp 12:00 --timestop 13:00 -j DROP
            ;;

        5)
            iptables -A INPUT -m limit --limit 50/minute --limit-burst 200 -j ACCEPT
            #iptables -A INPUT -p tcp --syn -m limit --limit 30/sec –j ACCEPT
            iptables -A INPUT -j DROP
            ;;

        6)
            iptables -A INPUT -i lo -j ACCEPT
            iptables -A OUTPUT -o lo -j ACCEPT
            ;;

        *)
            echo "Usage:{start|stop|restart|condrestart|status}"
            exit 1

esac
