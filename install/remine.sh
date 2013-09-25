#!/bin/bash
#Instalar Redmine
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

sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:ondrej/redmine
sudo apt-get update
sudo apt-get install -y --force-yes redmine redmine-mysql

sudo ln -s /usr/share/redmine/public /var/www/redmine
sudo apt-get install -y libapache2-mod-passenger
sudo sed "s/<\/IfModule>/  PassengerDefaultUser www-data\n<\/IfModule>/g" /etc/apache2/mods-available/passenger.conf |  sponge /etc/apache2/mods-available/passenger.conf
sudo chmod a+x /usr/share/redmine/public
sed "s/<\/VirtualHost>/\tRailsBaseURI \/redmine\n\tPassengerResolveSymlinksInDocumentRoot on\n<\/VirtualHost>/g" /etc/apache2/sites-available/default |  sponge /etc/apache2/sites-available/default
sudo service apache2 restart

#Instalar plugin markdown
apt-get install -y ruby-redcarpet
cd /usr/share/redmine/lib/plugins
git clone https://github.com/alminium/redmine_redcarpet_formatter

#Instalar platuml
#apt-get install -y graphviz
#cd /usr/bin
#echo '#!/bin/bash' > plantuml
#echo "/usr/bin/java -Djava.io.tmpdir=/var/tmp -jar /usr/share/plantuml/lib/plantuml.jar ${@}" >> plantuml
#chmod +x plantuml
#cd /usr/share
#mkdir plantuml
#cd plantuml
#mkdir lib 
#cd lib
#wget http://sourceforge.net/projects/plantuml/files/plantuml.jar
#cd /usr/share/redmine/lib/plugins
#git clone https://github.com/ndl/wiki_external_filter.git
#
#cd /usr/share/redmine/lib/plugins/wiki_external_filter
#sed "s/RAILS_DEFAULT_LOGGER./::Rails.logger./g" /usr/share/redmine/lib/plugins/wiki_external_filter/init.rb |sponge  /usr/share/redmine/lib/plugins/wiki_external_filter/init.rb

