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
##

# Example
# -------
# 
##

#Parameters 
ConnectSSH=$1

#Retrieve IP from param
IP=$(echo $ConnectSSH | cut -f2 -d"@")

#Connection
if ssh-keygen -q -F "$IP" # test if IP is already present in known host (if so we already connected once and the bashrc file il already uploaded)
then
	ssh -o "StrictHostKeyChecking no" $ConnectSSH -t 'source ~/.bashrc;bash -l' 
else 
	scp -o "StrictHostKeyChecking no" /home/aleresche/bashrc_remote $ConnectSSH:/home/syssupale/
	ssh -o "StrictHostKeyChecking no" $ConnectSSH -t 'mv ~/bashrc_remote ~/.bashrc;source ~/.bashrc;bash -l'
fi