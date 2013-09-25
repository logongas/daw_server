#!/bin/bash
#Instalar phpmyadmin
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

sudo apt-get install -y  phpmyadmin
echo "Include /etc/phpmyadmin/apache.conf" >> /etc/apache2/apache2.conf
echo "\$cfg['Servers'][\$i]['AllowDeny']['rules'] = array('allow root from all','deny % from all');" >> /etc/phpmyadmin/config.inc.php
echo "\$cfg['Servers'][\$i]['AllowDeny']['order'] = 'deny,allow';" >> /etc/phpmyadmin/config.inc.php
service apache2 restart