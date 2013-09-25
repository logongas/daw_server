#!/bin/bash
#Crear una base de datos
set -e

if [ "$#" -ne "3" ]; then
	echo "uso: `basename $0` --install database root_password"
	exit 1
fi

if [ "$1" != "--install" ]; then
	echo "uso: `basename $0` --install root_password"
	echo "El primer argumento debe ser --install"
	exit 1
fi



sed "s/@database/$2/g" add_database.sql > add_database.temp.sql
mysql -u root -p$3 < add_database.temp.sql
rm add_database.temp.sql

