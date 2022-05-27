#!/bin/bash
echo Actualizando repositorios
apt -y update
echo Instalando apache
apt -y install apache2
echo Instalando mysql
apt -y install mysql-server
echo Instalando php7.4
apt install -y software-properties-common apt-transport-https 
add-apt-repository -y ppa:ondrej/php
apt -y update
apt -y upgrade
apt install php7.4 libapache2-mod-php7.4 -y
systemctl restart apache2
echo Instalando repositorio de curieplaform
cd /var/www/html/
echo Borrando contenido del directorio html
rm -fr * .*
echo Instalando git
apt -y install git
# https://<usuario>:<contraseña>@bitbucket.org/<usuario>/<repositorio>.git 
# <contraseña> = Desde bitbucket arriba a la derecha click en el icono de usuario>Personal settings>App passwords>Create app password
git clone https://mguerreroitop:BgMhx4gMvfG6BUgdJvUw@bitbucket.org/mguerreroitop/test.git .
#echo Creando la base de datos
bash kubernetes/init.sh
echo Instalando extensiones de php
apt -y install php7.4-bcmath php7.4-curl php7.4-gd php7.4-intl php7.4-imap  php7.4-ldap php7.4-mbstring php7.4-mysql php7.4-soap php7.4-xml php7.4-zip  php7.4-tidy
echo Habilitando de php7.4
update-alternatives --set php /usr/bin/php7.4
echo Ejecutando configuraciones de php.ini
sed -i "s/memory_limit = 128M/memory_limit = 768M/g" "/etc/php/7.4/apache2/php.ini" >/dev/null
sed -i "s/post_max_size = 8M/post_max_size = 64M/g" "/etc/php/7.4/apache2/php.ini" >/dev/null
sed -i "s/;max_input_vars = 1000/max_input_vars = 5000/g" "/etc/php/7.4/apache2/php.ini" >/dev/null
sed -i "s/;extension=imap/extension=imap/g" "/etc/php/7.4/apache2/php.ini" >/dev/null
sed -i "s/;extension=ldap/extension=ldap/g" "/etc/php/7.4/apache2/php.ini" >/dev/null
sed -i "s/;extension=mbstring/extension=mbstring/g" "/etc/php/7.4/apache2/php.ini" >/dev/null
sed -i "s/;extension=intl/extension=intl/g" "/etc/php/7.4/apache2/php.ini" >/dev/null
sed -i "s/;extension=pdo_mysql/extension=pdo_mysql/g" "/etc/php/7.4/apache2/php.ini" >/dev/null
sed -i "s/;extension=soap/extension=soap/g" "/etc/php/7.4/apache2/php.ini" >/dev/null
sed -i "s/;extension=xmlrpc/extension=xmlrpc/g" "/etc/php/7.4/apache2/php.ini" >/dev/null
sed -i "s/;extension=xsl/extension=xsl/g" "/etc/php/7.4/apache2/php.ini" >/dev/null
sed -i "s/;extension=tidy/extension=tidy/g" "/etc/php/7.4/apache2/php.ini" >/dev/null
echo Reiniciando apache
systemctl restart apache2
echo Instalando yarn
apt -y remove cmdtest yarn nodejs
apt -y install curl
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
apt -y install curl dirmngr apt-transport-https lsb-release ca-certificates
curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
apt -y update
apt-key adv --refresh-keys --keyserver keyserver.ubuntu.com
apt update
apt install -y yarn nodejs
npm install --location=global npm@8.11.0
npm i -location=global yarn
echo Instalando librerias YARN
yarn install --production=true --modules-folder public_html/crm/libraries/
curl --compressed -o- -L https://yarnpkg.com/install.sh | bash
yarn upgrade --production=true --modules-folder public_html/crm/libraries/
echo Instalando composer
apt -y install php-cli unzip
curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
HASH=`curl -sS https://composer.github.io/installer.sig`
php -r "if (hash_file('SHA384', '/tmp/composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer
echo COMANDO STANDARD O PARA SISTEMA CURIEPLATFORM
yes |  composer install --no-dev
echo COMANDO STANDARD O PARA SISTEMA CURIEPLATFORM
yes |  composer upgrade --no-dev -W
systemctl restart apache2
