#!/bin/bash
#Instalador global
set -e

ask() { 
install="false"
while true; do
    read -p "Deseas instalar $* (s/n)?" answer
    case $answer in
        [Ss]* ) install="true"; break;;
        [Nn]* ) install="false"; break;;
        * ) echo "Solo se permite 's' o 'n'";;
    esac
done
}

read -p "Contraseña maestra:" master_password

./common.sh
ask MySQL
if [ "$install" == "true" ]; then
	./mysql.sh --install
	
        echo "Ahora podra anyadir nuevas bases de datos a mysql."
        echo "Cada base de datos creara un usuario con el mismo nombre que la base de datos y con password igual al nombre del usuario"
	echo "Escribe el nombre de las bases de datos a crear,separadas por espacios ([ENTER] para no crear ninguna):"
	read $databases
	for database in $databases
	do
		add_database.sh --install $database $master_password
	done
fi


ask Apache
if [ "$install" == "true" ]; then
	instalado_apache=true
	service apache2 start
	
	ask Dokuwiki
	if [ "$install" == "true" ]; then
		./dokuwiki.sh --install
	fi

	ask phpMyAdmin
	if [ "$install" == "true" ]; then
		./phpmyadmin.sh --install
	fi

	ask Redmine
	if [ "$install" == "true" ]; then
		./remine.sh --install master_password
	fi

	ask La página de Inicio
	if [ "$install" == "true" ]; then
		./pagina_inicio.sh --install
	fi
else
	instalado_apache=false
	service apache2 stop
fi




ask Tomcat
if [ "$install" == "true" ]; then
	if [ "$instalado_apache" == "true" ]; then
		tomcat_port=8080
		tomcat_ssh_port=8443
	else
		tomcat_port=80
		tomcat_ssh_port=443
	fi
	read -p "Tamaño minimo del Heap en MB para Tomcat:" min_heap_size_mb
	./java.sh --install
	./tomcat.sh --install $tomcat_port $tomcat_ssh_port $master_password $min_heap_size_mb
	
	if [ "$instalado_apache" == "true" ]; then
		./apache_and_tomcat.sh --install 
		./add_tomcat_app_to_apache.sh --install manager
	fi
	
	
	ask Sonar
	if [ "$install" == "true" ]; then
		./sonar.sh --install $master_password
		
		if [ "$instalado_apache" == "true" ]; then 
			./add_tomcat_app_to_apache.sh --install sonar
		fi
		
	fi

	ask Jenkins
	if [ "$install" == "true" ]; then
		./jenkins.sh --install $master_password
		
		if [ "$instalado_apache" == "true" ]; then 
			./add_tomcat_app_to_apache.sh --install jenkins
		fi		
	fi

	ask GitBlit
	if [ "$install" == "true" ]; then
		./gitblit.sh --install 
		
		if [ "$instalado_apache" == "true" ]; then 
			./add_tomcat_app_to_apache.sh --install git
		fi	
	fi		
	
	service apache2 restart
	
fi

ask New Relic
if [ "$install" == "true" ]; then
    echo "Para instalar newrelic necesita hacer creado previamente una cuenta en https://newrelic.com y tener una 'License Key'"

    echo "Confirme:"
    ask New Relic
    if [ "$install" == "true" ]; then
        echo "New Relic License Key:"
        read license_key
        ./newrelic.sh --install $license_key
    fi
fi	




