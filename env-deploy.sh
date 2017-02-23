#!/bin/bash
#===========================================================================================================================================================================================================
#		RRP V2	Deployment script  - DEV & STG env only				
#
#		made by aleresche						
#		version 1.0.1													- create file structure
#																		- create database & dedicated user
#																		- create nginx config 
#===========================================================================================================================================================================================================

##
#Variables
##
DOMAIN=
DATABASE=
DBUSER=
DBUSER_PWD=
MYSQL_PASSWORD=xxxxxxx

#Creating File Structure
mkdir /var/www/vhosts/$DOMAIN
mkdir /var/www/vhosts/$DOMAIN/httpdocs
cp default_page/* /var/www/vhosts/$DOMAIN/httpdocs/
chown nginx:www-data -R /var/www/vhosts/$DOMAIN
chmod 2775 -R /var/www/vhosts/$DOMAIN
if [ -f /var/www/vhosts/$DOMAIN/httpdocs/index.php ];
then
   echo "File structure created successfully...."
else
   echo "File structure not correct.... please check"
fi


 
#mysql db & user installation/configuration
mysql -uroot -p$MYSQL_PASSWORD << QUERY_INPUT
CREATE DATABASE $DATABASE;
CREATE USER $DBUSER@localhost IDENTIFIED BY '$DBUSER_PWD';
GRANT ALL PRIVILEGES ON $DATABASE.* TO $DBUSER IDENTIFIED BY '$DBUSER_PWD';
FLUSH PRIVILEGES;
QUERY_INPUT
echo "Database Created"


#nginx configuration
cp nginx.conf  /etc/nginx/conf.d/$DOMAIN.conf
sed -i -e s/DOMAINNAME/$DOMAIN/g /etc/nginx/conf.d/$DOMAIN.conf
echo "Nginx Configuration created..."

#Service restart
systemctl reload nginx php-fpm
