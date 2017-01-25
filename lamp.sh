#!/bin/bash
#Skriptas veikiantis su centos 6.8
#Automatiskai parsiuncia lamp ir paruosia wordress diegima

programs=(httpd mysql-server php php-mysql wget unzip)

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

echo "Ar atsiusti naujausia wordpress versija /var/www/html/ kataloga?"
katalogas=/var/www/html
klausti && (cd $katalogas && wget -O $katalogas/wordpress.zip https://wordpress.org/latest.zip && unzip $katalogas/wordpress.zip)  || echo "Siuntimas atsauktas"

echo "Ar pakeisti wordpress chown, i apache?"
klausti && chown -R apache:apache $katalogas/wordpress

echo "Ar startuoti servisus: httpd, mysql"
klausti && service httpd start && service mysqld start || echo "Servisasi nepaleisti"

echo "Ar sukurti mysql duomenu baze ir vartotoja wordpressui?"
klausti && mysql -u root -e "create database wordpress; GRANT ALL PRIVILEGES ON wordpress.* TO username@localhost IDENTIFIED BY 'password'"



