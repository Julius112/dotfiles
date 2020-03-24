#!/bin/bash

STATE_FILE=/home/julius/.unison/status
NAS_IP_INT="192.168.4.113"

function sync {
	echo "syncing $1..."
	/opt/bin/unison $1
	if [ $? -eq 0 ]; then
		sed -i -e "s/$1=./$1=1/g" $STATE_FILE && pkill -RTMIN+1 i3blocks
		echo "sucessfully synced $1"
	else
		sed -i -e "s/$1=./$1=0/g" $STATE_FILE && pkill -RTMIN+1 i3blocks
		echo "failed syncing $1"
	fi
}

/usr/bin/keychain $HOME/.ssh/id_ed25519
source $HOME/.keychain/$HOSTNAME-sh
ssh-add -l > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
	exit
fi

if ! /usr/bin/ping -c 1 $NAS_IP_INT > /dev/null; then
	PROFILE=ext
else
	PROFILE=int
fi

echo "Setting Profile to $PROFILE"

echo "Taking Snapshot prior to Sync..."
/home/julius/.scripts/snapshot.sh


sed -i "1s/.*/active_sync/" $STATE_FILE && pkill -RTMIN+1 i3blocks
sync documents_$PROFILE
sync music_$PROFILE
sync videos_$PROFILE
sync pictures_$PROFILE
sed -i "1s/.*/idle/" $STATE_FILE && pkill -RTMIN+1 i3blocks

echo "Mounting Familie..."
curlftpfs -o utf8,ssl,cacert=/home/julius/niedserver.pem,no_verify_peer ftp://niedworok.no-ip.org:1321/Familie /mnt/familie
sed -i "1s/.*/active_sync/" $STATE_FILE && pkill -RTMIN+1 i3blocks
sync familie
sed -i "1s/.*/idle/" $STATE_FILE && pkill -RTMIN+1 i3blocks
