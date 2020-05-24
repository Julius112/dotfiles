#!/bin/bash

STATE_FILE=/home/julius/.unison/status
NAS_IP_INT="192.168.4.112"

function sync {
	echo "syncing $1..."
	/opt/bin/unison $1_$2
	if [ $? -eq 0 ]; then
		sed -i -e "s/$1=./$1=1/g" $STATE_FILE
		echo "sucessfully synced $1"
	else
		sed -i -e "s/$1=./$1=0/g" $STATE_FILE
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


sed -i "1s/.*/active_sync/" $STATE_FILE
sync documents $PROFILE
sync familie $PROFILE
sed -i "1s/.*/idle/" $STATE_FILE
