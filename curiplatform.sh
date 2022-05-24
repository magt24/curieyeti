#!/bin/bash
echo Actualizando repositorios
sudo apt -y update
echo Instalando apache
sudo apt -y install apache2
echo Instalando mysql
sudo apt -y install mysql-server
echo Instalando php7.4
sudo apt install software-properties-common apt-transport-https -y
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update
sudo apt upgrade
sudo apt install php-7.4 libapache2-mod-php7.4 -y
sudo systemctl restart apache2
echo Instalando repositorio de curieplaform
cd /var/www/html/
echo Borrando contenido del directorio html
sudo rm -fr * .*
echo Instalando git
sudo apt -y install git
# https://<usuario>:<contraseña>@bitbucket.org/<usuario>/<repositorio>.git 
# <contraseña> = Desde bitbucket arriba a la derecha click en el icono de usuario>Personal settings>App passwords>Create app password
sudo git clone https://mguerreroitop:BgMhx4gMvfG6BUgdJvUw@bitbucket.org/mguerreroitop/test.git .
#echo Creando la base de datos
sudo bash kubernetes/init.sh
echo Instalando extensiones de php
sudo apt -y install php7.4-bcmath php7.4-curl php7.4-gd php7.4-intl php7.4-imap  php7.4-ldap php7.4-mbstring php7.4-mysql php7.4-soap php7.4-xml php7.4-zip  php7.4-tidy
echo Habilitando de php7.4
sudo update-alternatives --set php /usr/bin/php7.4
echo Ejecutando configuraciones de php.ini
sudo sed -i "s/memory_limit = 128M/memory_limit = 768M/g" "/etc/php/7.4/apache2/php.ini" >/dev/null
sudo sed -i "s/post_max_size = 8M/post_max_size = 64M/g" "/etc/php/7.4/apache2/php.ini" >/dev/null
sudo sed -i "s/;max_input_vars = 1000/max_input_vars = 5000/g" "/etc/php/7.4/apache2/php.ini" >/dev/null
sudo sed -i "s/;extension=imap/extension=imap/g" "/etc/php/7.4/apache2/php.ini" >/dev/null
sudo sed -i "s/;extension=ldap/extension=ldap/g" "/etc/php/7.4/apache2/php.ini" >/dev/null
sudo sed -i "s/;extension=mbstring/extension=mbstring/g" "/etc/php/7.4/apache2/php.ini" >/dev/null
sudo sed -i "s/;extension=intl/extension=intl/g" "/etc/php/7.4/apache2/php.ini" >/dev/null
sudo sed -i "s/;extension=pdo_mysql/extension=pdo_mysql/g" "/etc/php/7.4/apache2/php.ini" >/dev/null
sudo sed -i "s/;extension=soap/extension=soap/g" "/etc/php/7.4/apache2/php.ini" >/dev/null
sudo sed -i "s/;extension=xmlrpc/extension=xmlrpc/g" "/etc/php/7.4/apache2/php.ini" >/dev/null
sudo sed -i "s/;extension=xsl/extension=xsl/g" "/etc/php/7.4/apache2/php.ini" >/dev/null
sudo sed -i "s/;extension=tidy/extension=tidy/g" "/etc/php/7.4/apache2/php.ini" >/dev/null
echo Reiniciando apache
sudo systemctl restart apache2
echo Instalando yarn
sudo apt -y remove cmdtest yarn nodejs
sudo apt -y install curl
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt -y install curl dirmngr apt-transport-https lsb-release ca-certificates
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-key adv --refresh-keys --keyserver keyserver.ubuntu.com
sudo apt update
sudo apt install -y nodejs
sudo npm i -g yarn 
echo Instalando librerias YARN
sudo yarn install --production=true --modules-folder public_html/crm/libraries/
sudo yarn upgrade --production=true --modules-folder public_html/crm/libraries/
echo Instalando composer
sudo apt -y install php-cli unzip
curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
HASH=`curl -sS https://composer.github.io/installer.sig`
php -r "if (hash_file('SHA384', '/tmp/composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer
cd /var/www/html/curieyeti/
echo COMANDO STANDARD O PARA SISTEMA CURIEPLATFORM
yes | sudo composer install --no-dev
echo COMANDO STANDARD O PARA SISTEMA CURIEPLATFORM
yes | sudo composer upgrade --no-dev -W
sudo systemctl restart apache2
