#!/bin/bash

STATE_FILE=/home/julius/.unison/status

function sync {
	echo "syncing $1..."
	/opt/bin/unison $1
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

sed -i "1s/.*/active_sync/" $STATE_FILE
sync documents
sync music
sync videos
sync pictures
#sync familie
sed -i "1s/.*/idle/" $STATE_FILE
