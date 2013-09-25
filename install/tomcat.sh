#!/bin/bash
#Instalar Tomcat
set -e

if [ $# -ne 5 ]; then
  	echo "uso: `basename $0` --install tomcat_http_port tomcat_https_port tomcat_password min_heap_size_mb"
	echo "ejemplos:"
	echo "`basename $0` --install 80 443 s3cr3t 200"
	echo "`basename $0` --install 8080 8443 s3cr3t 500"
  	exit 1
fi

if [ "$1" != "--install" ]; then
  	echo "uso: `basename $0` --install tomcat_http_port tomcat_https_port tomcat_password min_heap_size_mb"
	echo "ejemplos:"
	echo "`basename $0` --install 80 443 s3cr3t 200"
	echo "`basename $0` --install 8080 8443 s3cr3t 500"
	echo "El primer argumento debe ser --install"
	exit 1
fi

HTTP_PORT=$2
HTTPS_PORT=$3
PASSWORD=$4
MIN_HEAP_SIZE=$5


#Parar el apache
if [ "$HTTP_PORT" == "80" ]; then
	service apache2 stop
	update-rc.d -f apache2 disable
fi


#Instalar tomcat
apt-get -y install tomcat7
apt-get -y install tomcat7-admin
service tomcat7 stop

chown -R tomcat7:tomcat7 /etc/tomcat7
chown -R tomcat7:tomcat7 /var/lib/tomcat7

#Cambiar los puerto  80 y 443
xmlstarlet ed -u "//Connector[@port=8080]/@port" -v $HTTP_PORT          /etc/tomcat7/server.xml | sponge /etc/tomcat7/server.xml
xmlstarlet ed -u "//Connector[@redirectPort=8080]/@redirectPort" -v $HTTP_PORT  /etc/tomcat7/server.xml | sponge /etc/tomcat7/server.xml
xmlstarlet ed -u "//Connector[@port=8443]/@port" -v $HTTPS_PORT         /etc/tomcat7/server.xml | sponge /etc/tomcat7/server.xml
xmlstarlet ed -u "//Connector[@redirectPort=8443]/@redirectPort" -v $HTTPS_PORT /etc/tomcat7/server.xml | sponge /etc/tomcat7/server.xml

#Añadir el usuario admin de tomcat
xmlstarlet ed -i "//Realm[@resourceName=\"UserDatabase\"]" --type attr -n digest -v MD5 /etc/tomcat7/server.xml | sponge /etc/tomcat7/server.xml
tomcatpassword=$(/usr/share/tomcat7/bin/digest.sh -a MD5 $PASSWORD |cut -d ":" -f2)
xmlstarlet ed -s "//tomcat-users" --type elem -n kkkkk  -v ""  /etc/tomcat7/tomcat-users.xml | sponge /etc/tomcat7/tomcat-users.xml
sed "s/<kkkkk\/>/<role rolename=\"manager\" \/>\n<role rolename=\"admin\" \/>\n<role rolename=\"manager-gui\"\/>\n<role rolename=\"manager-script\"\/>\n<user username=\"admin\" password=\"$tomcatpassword\" roles=\"manager,admin,manager-gui,manager-script\" \/>/g" /etc/tomcat7/tomcat-users.xml | sponge /etc/tomcat7/tomcat-users.xml
chown tomcat7:tomcat7 /etc/tomcat7/*

#Personalizar la memoria, idioma
sed "s/\-Xmx128m//g"  /etc/default/tomcat7 | sponge /etc/default/tomcat7
echo JAVA_OPTS=\"\${JAVA_OPTS} -Xms"$MIN_HEAP_SIZE"m -Xmx2048m -XX:MaxPermSize=512m\" >> /etc/default/tomcat7
echo JAVA_OPTS=\"\${JAVA_OPTS} -Duser.language=es -Duser.country=ES\"    >> /etc/default/tomcat7

#Permitir que se pueda "conectar" al puerto 80
sed "s/#AUTHBIND=no/AUTHBIND=yes/g" /etc/default/tomcat7 | sponge /etc/default/tomcat7


#Aumentar el tamaño maximo que puede tener un war al subirlo
xmlstarlet ed -u "//*[name()='max-file-size']" -v 104857600          /usr/share/tomcat7-admin/manager/WEB-INF/web.xml | sponge /usr/share/tomcat7-admin/manager/WEB-INF/web.xml
xmlstarlet ed -u "//*[name()='max-request-size']" -v 104857600          /usr/share/tomcat7-admin/manager/WEB-INF/web.xml | sponge /usr/share/tomcat7-admin/manager/WEB-INF/web.xml
chown -R tomcat7:tomcat7 /usr/share/tomcat7-admin


#copiar el driver de mysql
apt-get -y install libmysql-java
cp /usr/share/java/mysql-connector-java.jar /usr/share/tomcat7/lib
chmod 777 /usr/share/tomcat7/lib/mysql-connector-java.jar


chown -R tomcat7:tomcat7 /etc/tomcat7
chown -R tomcat7:tomcat7 /var/lib/tomcat7

chown -R tomcat7:tomcat7 /usr/share/tomcat7/      
chown -R tomcat7:tomcat7 /usr/share/tomcat7-admin/ 
chown -R tomcat7:tomcat7 /usr/share/tomcat7-root/


service tomcat7 start
