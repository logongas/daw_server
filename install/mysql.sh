#!/bin/bash
#Instalar mysql
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

apt-get -y install mysql-server

#mysql tablas en minisculas
sed "s/\[mysqld\]/\[mysqld\]\nlower_case_table_names=1/g" /etc/mysql/my.cnf | sponge /etc/mysql/my.cnf
#Permitir que se puedan conectar desde otra máquina
sed "s/bind-address/#bind-address/g"                      /etc/mysql/my.cnf | sponge /etc/mysql/my.cnf
service mysql restart


