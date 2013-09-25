#!/bin/bash
#Instalar dokuwiki
set -e

if [ "$#" -ne "1" ]; then
	echo "uso: `basename $0` --install"
	exit 1
fi

if [ "$1" != "--install" ]; then
	echo "uso: `basename $0` --install"
	echo "El primer argumento debe ser --install"
	exit 1
fi

cd /var/www
wget http://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz
tar xvf dokuwiki-stable.tgz
rm dokuwiki-stable.tgz
mv dokuwiki-* dokuwiki
chown -R www-data:www-data ./dokuwiki
sed "/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride all/g" /etc/apache2/sites-available/default | sponge /etc/apache2/sites-available/default

sudo service apache2 restart