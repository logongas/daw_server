#!/bin/bash
#Instalar Pagina de inicio
set -e

if [ "$#" -ne "1" ]; then
	echo "uso: `basename $0` --install "
	echo "Debe haber 1 argumento"
	exit 1
fi

if [ "$1" != "--install" ]; then
	echo "uso: `basename $0` --install password"
	echo "El primer argumento debe ser --install"
	exit 1
fi


cp -r ../public_html/* /var/www