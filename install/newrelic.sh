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
wget http://download.newrelic.com/newrelic/java-agent/newrelic-agent/2.21.4/newrelic-agent2.21.4.zip
unzip newrelic-agent2.21.4.zip
sed "s/app_name: My Application/app_name: $(hostname)/g" ./newrelic/newrelic.yml | sponge ./newrelic/newrelic.yml
sed "s/<%= license_key %>/$license_key/g" ./newrelic/newrelic.yml | sponge ./newrelic/newrelic.yml
echo JAVA_OPTS=\"\${JAVA_OPTS} -javaagent:/home/newrelic/newrelic/newrelic.jar\"    >> /etc/default/tomcat7
chown -R tomcat7:tomcat7 /home/newrelic

service tomcat7 restart
