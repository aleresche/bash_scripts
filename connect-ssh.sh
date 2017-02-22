
#!/bin/bash
# Connect SSH with specifying Color Scheme 

#  Features:
#  -------
#  Connect to a Specified remote Server from Old Neva using SSH client
#  use usual pwd to allow gain time
# # 

#  Usage:
#  -------
#  ./connect-ssh.sh <IP OF SERVER>
#
#  Example:
#  ---------
#  ./connect-ssh.sh syssupale@10.1.1.108
# # 

#  Parameters:
#  -----------
#  user@remote eg: syssupale@10.1.1.108
# #
ConnectSSH=$1

scp -o "StrictHostKeyChecking no" /home/aleresche/bashrc_remote $ConnectSSH:/home/syssupale
ssh -o "StrictHostKeyChecking no" $ConnectSSH 'source /home/syssupale/bashrc_remote'' 








