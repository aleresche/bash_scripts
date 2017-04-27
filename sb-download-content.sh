#!/bin/bash
#
# Description
# -----------
# Bash Script to retrieve web content + DB dump of a smallbiz website
# WARNING: make sure you have enough permission with the user so he can safely connect through SSH and dump the database
##

# Example
# -------
#  ./sb-download-content.sh <username> <password> <websitename> <databasename>
#
#  to backup example.com website :
#  ./sb-download-content.sh root pass123 example.com exampledb
##

# Misc
# -------
#  Version 1.0
#  Made by aleresche
##

##########################################################################################################################################
#  Variables
##########################################################################################################################################
## Parameters
## Source login (need to find a better way to store it)
LOGIN=$1
PWD=$2
WebsiteName=$3
dbname=$4

## Color Code Variables
Cyan='\033[0;35m'
Yellow='\033[0;33m'
EndColor='\033[0m\n'

##########################################################################################################################################
#  MAIN CODE
##########################################################################################################################################
## SOURCE SERVER
printf "${Yellow}Connecting to Source Server and downloading content...${EndColor}"
## Retrieving web content
ssh $login@$SRV -p 2202  "tar -zcvf  /var/www/vhosts/$WebsiteName" > $WebsiteName.content.tar.gz
printf "content locally copied to $pwd"
## Retrieving Database content
printf "starting Database dump..."
ssh $login@$SRV -p 2202  "mysqldump -u -p $dbname | gzip $dbname.gz"
printf "dump created downloading content..."
scp -P 2202 $login@$SRV:~/\{$dbname.gz} .
