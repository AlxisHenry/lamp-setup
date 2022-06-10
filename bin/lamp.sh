#!/bin/bash

Apache () {

	echo "---------------------";
	echo "Installation d'Apache";
	echo "---------------------";

	sudo apt install apache2 -y;

	ApacheConfiguration;

	echo "----------------------";
	echo "Configuration d'Apache";
    echo "----------------------";		

	echo "-------------";
	echo "URL REWRITING";
    echo "-------------";		
		
	sudo a2enmod rewrite
	sudo service apache2 restart

	echo "-------------------------------";
	echo "Configuration d'Apache terminée";
    echo "-------------------------------";	

	echo "------------------------------";
	echo "Installation d'Apache terminée";
	echo "------------------------------";

}

PHP () {

	echo "-----------------------";
	echo "Installation de PHP 8.1";
	echo "-----------------------";

	sudo apt-get install software-properties-common -y;
	sudo add-apt-repository ppa:ondrej/php -y;
	sudo apt-get install php8.1 -y;
	sudo apt install php8.1-common php8.1-mysql php8.1-xml php8.1-xmlrpc php8.1-curl php8.1-gd php8.1-imagick php8.1-cli php8.1-dev php8.1-imap php8.1-mbstring php8.1-opcache php8.1-soap php8.1-zip php8.1-redis php8.1-intl -y

	echo "--------------------------------";
	echo "Installation de PHP 8.1 terminée";
	echo "--------------------------------";

}

MariaDB () {

	echo "-----------------------";
	echo "Installation de MariaDB";
	echo "-----------------------";

	sudo apt install mariadb-server -y
	sudo apt install mariadb-client-core-10.3 -y

	sudo mariadb -e "DROP USER IF EXISTS 'alexis'@'%';";
	sudo mariadb -e "CREATE USER 'alexis'@'%' IDENTIFIED BY 'alexis';";
	sudo mariadb -e "CREATE DATABASE IF NOT EXISTS main";
	sudo mariadb -e "GRANT ALL PRIVILEGES ON *.* TO 'alexis'@'%';";
	sudo mariadb -e "FLUSH PRIVILEGES;";

	echo "---------------------------------";
	echo "Configuration de MariaDB terminée";
	echo "User : alexis";
	echo "PWD  : alexis";
	echo "DB   : main";
	echo "acc  : ALL";
	echo "---------------------------------";

}

Composer () {

	echo "------------------------";
	echo "Installation de composer";
	echo "------------------------";

	sudo curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

	echo "---------------------------------";
	echo "Installation de composer terminée";
	echo "---------------------------------";
}

xDebug () {

	echo "----------------------";
	echo "Installation de xDebug";
	echo "----------------------";

	sudo apt-get install php-xdebug -y

	echo "-------------------------------";
	echo "Installation de xDebug terminée";
	echo "-------------------------------";

	xDebugConfiguration;

}

Samba () {

	echo "---------------------";
	echo "Installation de Samba";
	echo "---------------------";

	sudo apt install samba -y

	echo "-------------------------------------------------------------";
	echo "Ajout de la configuration du partage dans /etc/samba/smb.conf";
	echo "-------------------------------------------------------------";

	echo "[dev]" | sudo tee -a /etc/samba/smb.conf;
	echo "   comment = Sharing Dev Folder" | sudo tee -a /etc/samba/smb.conf;
	echo "   path = /var/www" | sudo tee -a /etc/samba/smb.conf;
	echo "   read only = no" | sudo tee -a /etc/samba/smb.conf;
	echo "   browseable = yes" | sudo tee -a /etc/samba/smb.conf;

	echo "-----------------------------------------";
	echo "SAISISSEZ LE MOT DE PASSE DU COMPTE SAMBA";
	echo "-----------------------------------------";

	sudo smbpasswd -a ubuntu;
	sudo service smbd restart;

	echo "--------------------------------------------";
	echo "Utilisateur ubuntu ajouté aux partages Samba";
	echo "--------------------------------------------";

}

phpMyAdmin () {

			echo "--------------------------------";
			echo "Installation de phpMyAdmin 5.1.3";
			echo "--------------------------------";

			echo "--------------------------------";
			echo "Suppresion des anciens fichiers.";
			echo "--------------------------------";

			sudo rm -rf /usr/share/phpmyadmin
			sudo rm -rf /var/lib/phpmyadmin/tmp

			echo "------------------------------------------------------------------------";
			echo "Récupération de la denière version de PMA, tar du dossier & suppression.";
			echo "------------------------------------------------------------------------";

			sudo wget https://files.phpmyadmin.net/phpMyAdmin/5.1.3/phpMyAdmin-5.1.3-english.tar.gz
			sudo tar -xf phpMyAdmin-5.1.3-english.tar.gz
			rm -rf phpMyAdmin-5.1.3-english.tar.gz

			echo "---------------------------------------------------------------------------------";
			echo "Récupération de la denière version de PMA, tar du dossier & suppression terminés.";
			echo "---------------------------------------------------------------------------------";

			echo "----------------------------------------------------------------------";
			echo "Création & déplacement de tous les fichiers dans /usr/share/phpmyadmin";
			echo "----------------------------------------------------------------------";

			sudo mkdir /usr/share/phpmyadmin
			sudo mv phpMyAdmin-5.1.3-english/* /usr/share/phpmyadmin/
			
			echo "----------------------------------------------------------------";
			echo "Création des dossiers et changement des droits PMA dans /var/lib";
			echo "----------------------------------------------------------------";

			sudo mkdir -p /var/lib/phpmyadmin/tmp
			sudo chown -R www-data:www-data /var/lib/phpmyadmin

			echo "----------------------------------";
			echo "Création du fichier config.inc.php";
			echo "----------------------------------";

			sudo cp /usr/share/phpmyadmin/config.sample.inc.php /usr/share/phpmyadmin/config.inc.php

			echo "--------------------------------";
			echo "Suppression de l'ancien dossier et lancement de la configuration.";
			echo "--------------------------------";

				sudo rm -rf phpMyAdmin-5.1.3-english

			echo "-----------------------------------------";
			echo "Installation de phpMyAdmin 5.1.3 terminée";
			echo "-----------------------------------------";

}

UpdateServer () {

			echo "----------------";
			echo "Update & Upgrade";
			echo "----------------";

			sudo apt update && sudo apt upgrade -y

			echo "-------------------------";
			echo "Update & Upgrade finished";
			echo "-------------------------";

}
 

AvahiDeamon () {

	# https://gist.github.com/davisford/5984768
	# Privilégier AvahiDeamon à une ip statique pour multipass

	echo "----------------------------------------------------------------";
    echo "Installation d'Avahi-Deamon pour publier le nom de domaine local";
    echo "----------------------------------------------------------------";

	sudo apt-get install avahi-daemon -y

	echo "---------------------";
    echo "Avahi-Deamon installé"; 
    echo "---------------------";
}

xDebugConfiguration () {

	echo "-----------------------";
	echo "Configuration de xDebug";
	echo "-----------------------";

	#todo: Configuration xdebug

	sudo systemctl restart apache2

	echo "--------------------------------";
	echo "Configuration de xDebug terminée";
	echo "--------------------------------";

}


clean () {

	echo "------------------";
	echo "Clean all packages";
	echo "------------------";

	sudo apt clean
	sudo apt autoclean -y
	sudo apt autopurge -y

}

GithubSshKey () {

	echo "-------------------------------------------------------------------";
	echo "Génération d'une clé ssh à lier à Github / Suppresion de l'ancienne";
	echo "-------------------------------------------------------------------";

	sudo rm -rf ${HOME}/.ssh/id_rsa
	sudo rm -rf ${HOME}/.ssh/id_rsa.pub

	ssh-keygen -b 4096 -t rsa -f ${HOME}/.ssh/id_rsa -N ""

	echo "-----------------------";
	echo "Configuration de Github";
	echo "-----------------------";

	git config --global user.name "AlxisHenry";
	git config --global user.email "alexis.henry150357@gmail.com";

}

NodeJS () {

	echo "-------------------------------------";
	echo "Update NodeJS lastest version v17.9.0";
	echo "-------------------------------------";

	curl -fsSL https://deb.nodesource.com/setup_17.x | sudo -E bash -
	
	sudo apt-get install -y nodejs -y

}

NPM () {

	echo "-------------------";
	echo "Installation de NPM";
	echo "-------------------";

	sudo apt-get install npm -y	

	echo "------------------";
	echo "Update NPM lastest";
	echo "------------------";

	sudo npm install -g npm@latest

}

echo "-----------------------------------------------------------";
echo "                                                           ";
echo "Installation & Configuration d'une Machine de développement";
echo "                                                           ";
echo "-----------------------------------------------------------";

UpdateServer;
Apache;
PHP;
UpdateServer;
MariaDB;
Samba;
Composer;
xDebug;
phpMyAdmin;
GithubSshKey;
NodeJS;
NPM;
clean;
AvahiDeamon;

echo "---------------------";
echo "Installation terminée";
echo "---------------------";