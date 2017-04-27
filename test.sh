	#!/bin/bash
    
	#Parameters
	SRV=80.80.234.140
	WebsiteName=imao.ch

#Source login (need to find a better way to store it)
LOGIN="biadm"
PWD="Smb12@bi"

	#SOURCE SERVER
	printf "Connecting to Source Server...."
	#Retrieving web content
	ssh $login@$SRV -p 2202  "sudo -i;tar -zcvf  /var/www/vhosts/$WebsiteName" > $WebsiteName.content.tar.gz
	printf "content locally copied to $pwd"