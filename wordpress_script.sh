#!/bin/bash

# Demander le nom de la base de données et le nom d'utilisateur pour MySQL
read -p "Entrez le nom de la base de données MySQL: " dbname
read -p "Entrez le nom d'utilisateur MySQL: " dbuser
read -s -p "Entrez le mot de passe MySQL: " dbpass

# Mise à jour des paquets existants
sudo apt-get update

# Installer MySQL et PHP
sudo apt-get install -y mysql-server php php-mysql

# Créer la base de données et l'utilisateur MySQL
sudo mysql -u root -e "CREATE DATABASE $dbname;"
sudo mysql -u root -e "GRANT ALL PRIVILEGES ON $dbname.* TO '$dbuser'@'localhost' IDENTIFIED BY '$dbpass';"

# Télécharger et extraire WordPress dans le répertoire /var/www/html/
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xvzf latest.tar.gz -C /var/www/html/
sudo rm latest.tar.gz

# Configuration de WordPress
sudo cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
sudo sed -i "s/database_name_here/$dbname/" /var/www/html/wordpress/wp-config.php
sudo sed -i "s/username_here/$dbuser/" /var/www/html/wordpress/wp-config.php
sudo sed -i "s/password_here/$dbpass/" /var/www/html/wordpress/wp-config.php

# Autoriser Apache à écrire sur les fichiers de WordPress
sudo chown -R www-data:www-data /var/www/html/wordpress/
sudo chmod -R 755 /var/www/html/wordpress/

echo "WordPress a été installé avec succès."
