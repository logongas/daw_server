#!/bin/bash
#Instalar Gitblit
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


#instalar gitblit
#Descargar el war de gitblit
#En WEB-INF/web.xml el  baseFolder es /srv/gitblit
#Renombrar eel fichero WAR a "gitblit.war" para que el path de la url no contenga la versión
sudo mkdir /srv/gitblit
sudo chown tomcat7:tomcat7 /srv/gitblit
cd /var/lib/tomcat7/webapps
sudo wget https://www.dropbox.com/s/fn2exocv58wpg4u/gitblit.war
mv gitblit.war git.war