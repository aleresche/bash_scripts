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
printf "${Cyan}Connecting to Source Server and downloading content...${EndColor}"
## Retrieving web content
ssh $login@$SRV -p 2202  "tar -zcvf  /var/www/vhosts/$WebsiteName" > $WebsiteName.content.tar.gz
if [ $? -eq 0 ]; then
    printf "${Cyan}Web content has been backed up to $WebsiteName.content.tar.gz${EndColor}"
else
    printf "${Yellow}An error Occuered while accessing the server, please check SSH login/pwd and IP address and make sure those are correct and suffisent${EndColor}"
    exit
fi
printf "${Cyan}content locally copied to $pwd${EndColor}"
## Create full backup of database
printf "${Cyan}starting Database dump...${EndColor}"
ssh $login@$SRV -p 2202  "mysqldump -u -p $dbname | gzip $dbname.gz"
if [ $? -eq 0 ]; then
    ## Retrieving backup locally 
    printf "${Cyan}dump created, downloading content...${EndColor}"
    scp -P 2202 $login@$SRV:~/\{$dbname.gz} .
else
    printf "${Yellow}An error Occuered while creating the sql dump, please check SSH & MySQL login/pwd and IP address and make sure those are correct and suffisent${EndColor}"
    exit
fi

