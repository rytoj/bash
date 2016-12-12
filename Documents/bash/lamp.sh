#!/bin/bash
#Skriptas veikiantis su centos 6.8
#Automatiskai parsiuncia lamp ir paruosia wordress diegimui

#kiek bitu os tikrinimas "getconf LONG_BIT"
#[ "$(arch)" == "x86_64" ] && mysql="mariadb"
[ "$(arch)" == "i686" ] && mysql="mysql-server" #"getconf LONG_BIT" = 32

programs=(httpd $mysql php php-mysql wget unzip)

function klausti() {
echo "[y/n]"
read x
if [ "$x" == "Y" ] || [ "$x" == "y" ]; then
        echo "Komanda vykdoma..."
elif [ "$x" == "N" ] || [ "$x" == "n" ]; then
    echo Komanda atsaukta
        (exit 1)
    fi

}

#Tikrinam ar sistemoje idiegta programos

for i in "${programs[@]}"
do
        rpm -q $i > /dev/null 2>&1
        if [ $? -eq 1 ]; then
                echo "Klaida: $i nerastas. Diegti? [y/n]"
                read x
        if [ "$x" == "Y" ] || [ "$x" == "y" ]; then
                echo "Diegiama $1"
                yum install $i -y
        elif [ "$x" == "N" ] || [ "$x" == "n" ]; then
                echo "Praleidžiam $i diegima"
        fi
        fi
done

chkconfig --list | egrep "http|mysql"
echo "Ar ijungti servisus httpd, mysql, kad veiktų po perkrovimo?"
klausti && chkconfig httpd on && chkconfig mysqld on || echo "Sevisai nebus ijungti."

echo "Ar atsiusti naujausia wordpress versiją ir ikelti į /var/www/html/ kataloga?"
katalogas=/var/www/html
klausti && (cd $katalogas && wget -O $katalogas/wordpress.zip https://wordpress.org/latest.zip && unzip $katalogas/wordpress.zip)  || echo "Siuntimas atsauktas"

echo "Ar pakeisti wordpress chown, i apache?"
klausti && chown -R apache:apache $katalogas/wordpress

echo "Ar pakeisti apache default porta?"
grep "^Listen" /etc/httpd/conf/httpd.conf
sestatus | head -1 ; sestatus | grep --color=auto "Current mode" #selinux statusas
httpdir="/etc/httpd/conf/httpd.conf"
klausti && read -e -p "Iveskite porto numerį: " portas  && ! [[ ! $portas || $portas = *[^0-9]* ]] && sed -i "s/^Listen.*/Listen ${portas}/" "$httpdir" && setenforce 0
 && grep ^Listen "$httpdir" || echo "Tik skaitines reiksmes"

echo "Ar perkrauti servisus: httpd, mysql"
klausti && service httpd restart && service mysqld restart || echo "Servisasi nepaleisti"

echo "Ar sukurti mysql duomenu baze ir vartotoja wordpressui?"
klausti && mysql -u root -e "create database wordpress; GRANT ALL PRIVILEGES ON wordpress.* TO username@localhost IDENTIFIED BY 'password'"
