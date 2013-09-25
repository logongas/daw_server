#!/bin/bash
#Instalar Sonar
set -e

if [ "$#" -ne "2" ]; then
	echo "uso: `basename $0` --install password"
	echo "Debe haber 2 argumentos"
	exit 1
fi

if [ "$1" != "--install" ]; then
	echo "uso: `basename $0` --install password"
	echo "El primer argumento debe ser --install"
	exit 1
fi


sudo mkdir /srv/jenkins
sudo chown tomcat7:tomcat7 /srv/jenkins
cd /var/lib/tomcat7/webapps
sudo wget http://mirrors.jenkins-ci.org/war/latest/jenkins.war
echo "JENKINS_HOME=\"/srv/jenkins\"" >> /etc/default/tomcat7