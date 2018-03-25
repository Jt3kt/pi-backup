#!/bin/bash
src="/"
dest=$1
host=$HOSTNAME
romsdir="/home/pi/RetroPie/roms"
exclude_list="/home/pi/scripts/pi-backup/exclude.txt"
#Verify destination provided
if [ -z "$dest" ];then
	echo "No destination supplied.  Exiting."
	exit 1
fi
#Verify remote connection
ssh -q -o BatchMode=yes -o ConnectTimeout=10 -i /home/pi/.ssh/id_rsa pi@$dest exit
if [ "$?" -ne "0" ]
then
       echo "Remote destination is not reachable"
       exit 1
fi
sudo rsync -achv -e "ssh -i /home/pi/.ssh/id_rsa" --info=progress2 --timeout=12000 --delete --chmod=+r --exclude-from=$exclude_list $src pi@$dest:$host/data
if [ -d "$romsdir"]; then
	sudo rsync -achv -e "ssh -i /home/pi/.ssh/id_rsa" --info=progress2 --timeout=12000 --delete --chmod=+r $romsdir pi@$dest:/util/roms
fi
# Check status
if [ "$?" -eq "0" ]
then
        echo "Backup complete."
else
        echo "Backup failed.  Need to debug."
fi

