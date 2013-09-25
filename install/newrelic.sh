#!/bin/bash
#Instalar new Relic
set -e

if [ "$#" -ne "2" ]; then
	echo "uso: `basename $0` --install license_key"
	echo "Debe haber 2 argumento"
	exit 1
fi

if [ "$1" != "--install" ]; then
	echo "uso: `basename $0` --install"
	echo "El primer argumento debe ser --install"
	exit 1
fi

#Monitorizar el servidor
wget -O /etc/apt/sources.list.d/newrelic.list http://download.newrelic.com/debian/newrelic.list
apt-key adv --keyserver hkp://subkeys.pgp.net --recv-keys 548C16BF
apt-get update
apt-get -y install newrelic-sysmond
nrsysmond-config --set license_key=$license_key
/etc/init.d/newrelic-sysmond start


#Monitorizar el Tomcat
mkdir /home/newrelic
cd /home/newrelic
wget https://rpm.newrelic.com/newrelic_agent2.20.0.zip
unzip newrelic_agent2.20.0.zip
sed "s/app_name: My Application/app_name: $(hostname)/g" /home/newrelic/newrelic/newrelic.yml | sponge /home/newrelic/newrelic/newrelic.yml
echo JAVA_OPTS=\"\${JAVA_OPTS} -javaagent:/home/newrelic/newrelic/newrelic.jar\"    >> /etc/default/tomcat7
chown -R tomcat7:tomcat7 /home/newrelic

service tomcat7 restart
