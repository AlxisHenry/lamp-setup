# Launch LAMP 
sh /home/ubuntu/linux-professional-environment/bin/lamp.sh

# Add public key to authorized_keys
cat /home/ubuntu/linux-professional-environment/.ssh/authorized_keys >> /home/ubuntu/.ssh/authorized_keys

# Ports file
sudo mv /home/ubuntu/linux-professional-environment/etc/ports.conf /etc/apache2/ports.conf

# Configs sites & configurations
sudo mv /home/ubuntu/linux-professional-environment/etc/apache2/conf-available/phpmyadmin.conf /etc/apache2/conf-available/phpmyadmin.conf
sudo mv /home/ubuntu/linux-professional-environment/etc/apache2/sites-available/laravel.conf /etc/apache2/sites-available/laravel.conf
sudo a2ensite laravel.conf
sudo a2dissite 000-default.conf
sudo a2enconf phpmyadmin.conf

# PhpMyAdmin
sudo mv /home/ubuntu/linux-professional-environment/etc/phpmyadmin/config.inc.php /usr/share/phpmyadmin/config.inc.php

# Apache Folders
sudo rm -rf /var/www/html
sudo mkdir /var/www/main

# Rigths
sudo chown -R www-data:www-data /usr/share/phpmyadmin
sudo chown -R root:root /etc/apache2
sudo chown -R ubuntu:ubuntu /var/www

# Restart Apache
sudo systemctl restart apache2

# Github ssh key
(ls ${HOME}/.ssh/id_rsa.pub && echo "Clé SSH publique :" && cat ${HOME}/.ssh/id_rsa.pub) || echo "Aucune clée SSH générée.";

# Reboot
sleep 5
sudo shutdown -r now