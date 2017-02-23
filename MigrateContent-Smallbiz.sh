#!/bin/bash
#
# Description
# -----------
# connect to the old server, excract and compress content, retrieve it Locally, upload and uncompress on source
# this script will be used/tested from WSL Bash
# ./MigrateContent-Smallbiz.sh <SourceIP> <DestinationIP> <domainName> <Database Name>
##

# Example
# -------
# ./MigrateContent-Smallbiz.sh 80.80.234.140 80.80.236.103 shop.neva-hosting.ch shopnevahosting
##

# Misc
# -------
# Author	:	Arnaud Leresche
# Version	:	0.2
##
##########################################################################################################################################
#  Variables
##########################################################################################################################################
#Params
SourceIP=$1
DestinationIP=$2
DomainName=$3
Database=$4

#Color Code
Cyan='\033[0;35m'
Yellow='\033[0;33m'
EndColor='\033[0m\n'

#Source login (need to find a better way to store it)
LOGIN="xxx"
PWD="xxx"

##########################################################################################################################################
#  Interactive Menu
##########################################################################################################################################
title="===== Migrate Content Tool Smallbiz ====="
prompt="Pick an option:"
options=("Backup Website Content" "Backup Website Database" "Transfert Content")

printf  "${Yellow}$title${EndColor}"
PS3="$prompt "
select opt in "${options[@]}" "Quit"; do 

    case "$REPLY" in

    1 ) printf "${Cyan}You picked $opt which is option $REPLY${EndColor}";bckupWebContent($SourceIP,$DomainName);;
    2 ) printf "${Cyan}You picked $opt which is option $REPLY${EndColor}";bckupDBContent($SourceIP,$Database);;
	3 ) printf "${Cyan}You picked $opt which is option $REPLY${EndColor}";UploadContent($DestinationIP,$DomainName);;

    $(( ${#options[@]}+1 )) ) printf "${Cyan}Goodbye!${EndColor}"; break;;
    *) printf "${Cyan}Invalid option. Try another one.${EndColor}";continue;;

    esac

done


##########################################################################################################################################
#  Function Backup Web Content
##########################################################################################################################################
function bckupWebContent {
	#Parameters
	SRV=$1
	WebsiteName=$2

	#SOURCE SERVER
	printf "${Cyan}Connecting to Source Server....${EndColor}"
	#Retrieving web content
	ssh $login@$SRV -p$PWD "tar -zcvf  /var/www/vhosts/$WebsiteName" > $WebsiteName.content.tar.gz
	echo "${Cyan}content locally copied to $pwd${EndColor}"
}

##########################################################################################################################################
#  Function Backup DB Content
##########################################################################################################################################
function bckupDBContent {
	SRV=$1
	DBName=$2

	#mysql db & user installation/configuration
	ssh $login@$SRV "mysqldump -uadmin -p`cat /etc/psa/.psa.shadow` $DBName  | gzip" > ./$DBName.sql.gz
	echo "${Cyan}Database has been copied to $pwd${EndColor}"
}

##########################################################################################################################################
#  Function Migrate content to new server
##########################################################################################################################################
function UploadContent {
	DestSRV=$1
	#set files path 
	DBPath=./$Database.sql.gz 
	ContentPath=./$DomainName.content.tar.gz
	#uses SSH access from syssupale (public on remote, private on local)
	scp -o "StrictHostKeyChecking no" $DBPath $DestSRV:/home/syssupale
	echo "${Cyan}Database has been uploaded...${EndColor}"
	scp -o "StrictHostKeyChecking no" $ContentPath $DestSRV:/home/syssupale
	echo "${Cyan}Web Content has been uploaded...${EndColor}"
}