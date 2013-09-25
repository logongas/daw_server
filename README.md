daw_server
==========

Instalación de servidores de producción y desarrollo para el ciclo de DAW.

Estos escript está hechos para trabajar en Ubuntu 12.04 recien instalado.


## Instalacion

```bash
apt-get update ; apt-get install -y git
git clone https://github.com/logongas/daw_server.git
cd daw_server
./install.sh
```

El script preguntará para instalar lo siguiente:
  * Apache2
  * Tomcat7 (cambiada contraseña)
  * redmine (Se cambia la sintaxis de la wiki a markdown)
  * dokuwiki
  * phpmyadmin
  * gitbit
  * jenkins
  * sonar
  * newrelic (Es necesario tener una cuenta en http://newrelic.com/ y una License Key)

Tambien se creará una página de inicio en /var/www para poder acceder a todos los productos instalados desde la web.
Deberás modificar el fichero /var/www/index.html para quitar los productos que no se han instalado.

Si se instala Apache,  Tomcat se instalará en el puerto 8080 y se enlazará mediante libapache2-mod-jk con apache. Para cada aplicación nueva que se instale en tomcat será necesario ejecutar el script `./add_tomcat_app_to_apache.sh --install app_name`
Si NO se instala Apache, Tomcat se instalará en el puerto 80.