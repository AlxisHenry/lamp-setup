#!/bin/bash

Development () {

	# Launch LAMP 
	sh /home/ubuntu/linux-professional-environment/bin/lamp.sh

	# PhpMyAdmin
	sudo mv /home/ubuntu/linux-professional-environment/etc/phpmyadmin/config.inc.php /usr/share/phpmyadmin/config.inc.php
	sudo mv /home/ubuntu/linux-professional-environment/etc/apache2/conf-available/phpmyadmin.conf /etc/apache2/conf-available/phpmyadmin.conf
	sudo chown -R www-data:www-data /usr/share/phpmyadmin

	Global

}

Tests () {

	# Launch LAMP 
	sh /home/ubuntu/linux-professional-environment/bin/setup-test-env.sh

	Global

}


Global () {

	# Aliases & scripts
	sudo mv /home/ubuntu/linux-professional-environment/home/ubuntu/.bashrc /home/ubuntu/.bashrc
	sudo mv /home/ubuntu/linux-professional-environment/bin/test-environment-scripts/up.sh /home/ubuntu/up.sh
	sudo mv /home/ubuntu/linux-professional-environment/bin/test-environment-scripts/prod.sh /home/ubuntu/prod.sh

	# Apache Folders
	sudo rm -rf /var/www/html
	sudo mkdir /var/www/main

	# Rigths
	sudo chown -R root:root /etc/apache2
	sudo chown -R ubuntu:ubuntu /var/www

	# Apache conf
	sudo mv /home/ubuntu/linux-professional-environment/etc/ports.conf /etc/apache2/ports.conf
	sudo mv /home/ubuntu/linux-professional-environment/etc/apache2/sites-available/laravel.conf /etc/apache2/sites-available/laravel.conf
	sudo a2ensite laravel.conf
	sudo a2dissite 000-default.conf

	# Add public key to authorized_keys
	cat /home/ubuntu/linux-professional-environment/.ssh/authorized_keys >> /home/ubuntu/.ssh/authorized_keys

	# Restart Apache
	sudo systemctl restart apache2

	# Github ssh key
	(ls ${HOME}/.ssh/id_rsa.pub && echo "Clé SSH publique :" && cat ${HOME}/.ssh/id_rsa.pub) || echo "Aucune clée SSH générée.";

	# Reboot
	sleep 2
	sudo shutdown -r now

}


while true; do
	read -p "Quel type d'installancer lancer ? " machine
		case $machine in
			[dev]* ) Development "dev"; break;;
			[test]* ) Tests "test"; break;;
			* ) echo "Répondez par dev, test ou prod.";;
		esac
done;

