#!/bin/bash
#Instalar Java 7
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

sudo apt-get install -y openjdk-7-jdk