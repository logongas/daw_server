#!/bin/bash
#Instalar Sonar
set -e

if [ "$#" -ne "2" ]; then
	echo "uso: `basename $0` --install password_database"
	exit 1
fi

if [ "$1" != "--install" ]; then
	echo "uso: `basename $0` --install password_database"
	echo "El primer argumento debe ser --install"
	exit 1
fi


sudo ./add_database.sh --install sonar $2

cd /srv
sudo wget http://dist.sonar.codehaus.org/sonar-3.6.2.zip
sudo unzip sonar-3.6.2.zip
sudo rm sonar-3.6.2.zip
sudo mv sonar-3.6.2 sonar
sudo sed "s/#SONAR_HOME=/SONAR_HOME=\/srv\/sonar/g" /srv/sonar/war/sonar-server/WEB-INF/classes/sonar-war.properties |  sponge /srv/sonar/war/sonar-server/WEB-INF/classes/sonar-war.properties
sudo sed "s/^sonar.jdbc.url:/#sonar.jdbc.url:/g" /srv/sonar/conf/sonar.properties  |  sponge /srv/sonar/conf/sonar.properties
sudo sed "s/^#sonar.jdbc.url:\s*jdbc:mysql/sonar.jdbc.url: jdbc:mysql/g" /srv/sonar/conf/sonar.properties |  sponge /srv/sonar/conf/sonar.properties
cd /srv/sonar/war
sudo ./build-war.sh
sudo chown -R tomcat7:tomcat7 /srv/sonar
sudo mv /srv/sonar/war/sonar.war /var/lib/tomcat7/webapps

