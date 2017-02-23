#!/bin/bash
# Synopsis
# -----
# Script to help transfering data from old neva smallbiz to new CS Cloudstack infra
##


#
# Description
# -----------
# connect to the old server, excract and compress content, retrieve it Locally, upload and uncompress on source
# this script will be used/tested from WSL Bash
# ./MigrateContent-Smallbiz.sh <SourceIP> <DestinationIP> <domainName>
##

# Example
# -------
# ./MigrateContent-Smallbiz.sh 80.80.234.140 80.80.236.103 shop.neva-hosting.ch
##
##########################################################################################################################################
#  Variables
##########################################################################################################################################
#Params
SourceIP=$1
DestinationIP=$2
DomainName=$3

#Color Code
Cyan='\033[0;35m'
Yellow='\033[0;33m'
EndColor='\033[0m\n'

#Source login (need to find a better way to store it)
LOGIN="biadm"
PWD="Smb12@bi"

##########################################################################################################################################
#  Interactive Menu
##########################################################################################################################################
title="===== Migrate Content Tool Smallbiz ====="
prompt="Pick an option:"
options=("Backup Website Content" "Backup Website Database" "Both")

printf  "${Yellow}$title${EndColor}"
PS3="$prompt "
select opt in "${options[@]}" "Quit"; do 

    case "$REPLY" in

    1 ) printf "${Cyan}You picked $opt which is option $REPLY${EndColor}";bckupWebContent($SourceIP,$DomainName);;
    2 ) printf "${Cyan}You picked $opt which is option $REPLY${EndColor}";;
	3 ) printf "${Cyan}You picked $opt which is option $REPLY${EndColor}";;

    $(( ${#options[@]}+1 )) ) printf "${Cyan}Goodbye!${EndColor}"; break;;
    *) printf "${Cyan}Invalid option. Try another one.${EndColor}";continue;;

    esac

done


##########################################################################################################################################
#  Function Backup Web Content
##########################################################################################################################################
function SrcbckupWebContent {
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
function SrcbckupDBContent {
	SRV=$1
	DBName=$2
	#Prepare CMD line to send on remote system (to avoid direct injection)
	MakeBackup="mysqldump -uadmin -p`cat /etc/psa/.psa.shadow` $DBName  | gzip"
	#mysql db & user installation/configuration
	ssh $login@$SRV $MakeBackup > ./$DBName.sql.gz

}