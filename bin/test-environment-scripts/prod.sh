# This script will update the production code

SendProject () {

  # Copy project
  sudo rm -rf /tmp/main
  sudo cp -r /var/www/main /tmp/main
  sudo chown -R ubuntu:ubuntu /tmp/main

  # Delete useless files/folders
  rm -rf /tmp/main/.git
  rm -rf /tmp/main/.github
  rm -rf /tmp/main/.gitignore
  rm -rf /tmp/main/.env.example
  rm -rf /tmp/main/.env.tests
  rm -rf /tmp/main/.env
  rm -rf /tmp/main/README.md
  rm -rf /tmp/main/artisan.md
  rm -rf /tmp/main/setup.sh
  rm -rf /tmp/main/tests/Scripts
  rm -rf /tmp/main/tests/dump.sql
  rm -rf /tmp/main/docs

  # Clean useless code
  rm -rf /tmp/main/resources/css
  rm -rf /tmp/main/resources/sass
  rm -rf /tmp/main/resources/js

  # Copy production .env file
  cp /tmp/main/.env.production /tmp/main/.env
  rm -rf /tmp/main/.env.production

  php artisan key:generate
 
  echo "Droits distants sur /var/www/main attribués à ubuntu"
  ssh ubuntu@92.222.16.109 -p 62303 'sudo chown -R ubuntu:ubuntu /var/www/main'

  echo "Lancement du transfert du code vers le serveur de production..."
  rsync -azP --exclude-from '/home/ubuntu/exclude_list' -e 'ssh -p 62303' /tmp/main/ ubuntu@92.222.16.109:/var/www/main

  echo "Droits distants sur /var/www/main attribués à ubuntu"
  ssh ubuntu@92.222.16.109 -p 62303 'sudo chown -R ubuntu:ubuntu /var/www/main'

  echo "Paramétrage de Laravel..."
  ssh ubuntu@92.222.16.109 -p 62303 'php /var/www/main/artisan optimize'
  ssh ubuntu@92.222.16.109 -p 62303 'php /var/www/main/artisan optimize:clear'
  ssh ubuntu@92.222.16.109 -p 62303 'php /var/www/main/artisan cache:clear'
  ssh ubuntu@92.222.16.109 -p 62303 'npm --prefix /var/www/main/ run tests'

  echo "Mise à jour des droits distants..."
  ssh ubuntu@92.222.16.109 -p 62303 'sudo chown -R www-data:www-data /var/www/main/public'
  ssh ubuntu@92.222.16.109 -p 62303 'sudo chown -R www-data:www-data /var/www/main/storage'
  ssh ubuntu@92.222.16.109 -p 62303 'sudo chown -R www-data:www-data /var/www/main/bootstrap'

}

echo '---------------------------';
echo 'Envoi du code en production';
echo '---------------------------';

SendProject;

echo '-------------------------';
echo 'Code envoyé en production';
echo '-------------------------';