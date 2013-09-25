#!/bin/bash
#Añadir una app de tomcat para que se vea desde Apache
set -e

if [ "$#" -ne "2" ]; then
	echo "uso: `basename $0` --install app_name"
	echo "Debe haber 2 argumentos"
	exit 1
fi

if [ "$1" != "--install" ]; then
	echo "uso: `basename $0` --install"
	echo "El primer argumento debe ser --install"
	exit 1
fi

echo "/$2|/*=ajp13_worker" >>  /etc/apache2/conf/extra/uriworkermap.properties


service apache2 restart

