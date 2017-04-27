#!/bin/bash
#
# Description
# -----------
# Bash Script to transfer custom bashrc to remote server, to force specific color/scheme for the shell
##

# Example
# -------
# ./connect-ssh.sh username@remoteserver
##

#Parameters 
ConnectSSH=$1

#Retrieve IP from param
IP=$(echo $ConnectSSH | cut -f2 -d"@")

if [[ $ConnectSSH == *"biadm"* ]]; then
  echo "biadm login detected..."
fi

#Connection
if ssh-keygen -q -F "$IP" # test if IP is already present in known host (if so we already connected once and the bashrc file il already uploaded)
then
	ssh -o "StrictHostKeyChecking no" $ConnectSSH -t 'source ~/.bashrc;bash -l' 
else 
	scp -o "StrictHostKeyChecking no" /home/aleresche/bashrc_remote $ConnectSSH:/home/syssupale/
	ssh -o "StrictHostKeyChecking no" $ConnectSSH -t 'mv ~/bashrc_remote ~/.bashrc;source ~/.bashrc;bash -l'
fi









