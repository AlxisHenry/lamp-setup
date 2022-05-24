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

	sudo mariadb -e "DROP USER IF EXISTS 'alexis'@localhost;";
	sudo mariadb -e "CREATE USER 'GLPI'@'%' IDENTIFIED BY 'GLPI_USER123*';";
	sudo mariadb -e "CREATE DATABASE IF NOT EXISTS GLPI";
	sudo mariadb -e "GRANT ALL PRIVILEGES ON GLPI.* TO 'alexis'@'localhost';";
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

UpdateServer () {

			echo "----------------";
			echo "Update & Upgrade";
			echo "----------------";

			sudo apt update && sudo apt upgrade -y

			echo "-------------------------";
			echo "Update & Upgrade finished";
			echo "-------------------------";

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
Composer;
xDebug;
NodeJS;
NPM;
clean;

echo "---------------------";
echo "Installation terminée";
echo "---------------------";