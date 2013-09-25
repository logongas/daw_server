#!/bin/bash
#Permitir acceder desde Apache a tomcat
set -e

if [ "$#" -ne "1" ]; then
	echo "uso: `basename $0` --install"
	echo "Debe haber 1 argumento"
	exit 1
fi

if [ "$1" != "--install" ]; then
	echo "uso: `basename $0` --install"
	echo "El primer argumento debe ser --install"
	exit 1
fi

apt-get install libapache2-mod-jk
cd /etc/apache2
mkdir conf
cd conf
mkdir extra
touch /etc/apache2/conf/extra/uriworkermap.properties
rm /etc/apache2/conf/extra/uriworkermap.properties
touch /etc/apache2/conf/extra/uriworkermap.properties
# echo "/jenkins|/*=ajp13_worker" >>  /etc/apache2/conf/extra/uriworkermap.properties
# echo "/sonar|/*=ajp13_worker" >>  /etc/apache2/conf/extra/uriworkermap.properties
# echo "/gitblit|/*=ajp13_worker" >>  /etc/apache2/conf/extra/uriworkermap.properties
# echo "/manager|/*=ajp13_worker" >>  /etc/apache2/conf/extra/uriworkermap.properties

#TOMCAT_PATHS="$@"
#for TOMCAT_PATH in $TOMCAT_PATHS
#do
#	echo "/${TOMCAT_PATH}|/*=ajp13_worker" >>  /etc/apache2/conf/extra/uriworkermap.properties
#done


sed "s/<\/VirtualHost>/JkMountFile \/etc\/apache2\/conf\/extra\/uriworkermap.properties\n<\/VirtualHost>/g" /etc/apache2/sites-enabled/000-default |  sponge /etc/apache2/sites-enabled/000-default

#Habilitar APJ en Tomcat, hay qyue quitar los 2 comentarios
linea=$(cat /etc/tomcat7/server.xml |grep -n "<Connector port=\"8009\" protocol=\"AJP/1.3\" redirectPort=\"8443\" />" |cut -d ":" -f1)
anterior=$[$linea-1]
echo $linea
echo $anterior
cat /etc/tomcat7/server.xml | sed "${anterior}d"  | sed "${linea}d" |sponge  /etc/tomcat7/server.xml


service apache2 restart
service tomcat7 restart
