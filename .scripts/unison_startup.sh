#!/bin/bash

STATE_FILE=/home/julius/.unison/status
NAS_IP_INT="192.168.4.113"

function sync {
	echo "syncing $1..." >> /tmp/unison_startup.log
	/opt/bin/unison $1
	if [ $? -eq 0 ]; then
		sed -i -e "s/$1=./$1=1/g" $STATE_FILE
		echo "sucessfully synced $1" >> /tmp/unison_startup.log
	else
		sed -i -e "s/$1=./$1=0/g" $STATE_FILE
		echo "failed syncing $1" >> /tmp/unison_startup.log
	fi
}

/usr/bin/keychain $HOME/.ssh/id_ed25519 >> /tmp/unison_startup.log 2>&1
source $HOME/.keychain/$HOSTNAME-sh >> /tmp/unison_startup.log 2>&1
ssh-add -l >> /tmp/unison_startup.log 2>&1
while [[ $? -ne 0 ]]; do
	sed -i "1s/.*/active_wait/" $STATE_FILE
	sleep 300
	/usr/bin/keychain $HOME/.ssh/id_ed25519 >> /tmp/unison_startup.log 2>&1
	source $HOME/.keychain/$HOSTNAME-sh >> /tmp/unison_startup.log 2>&1
	ssh-add -l >> /tmp/unison_startup.log 2>&1
done

if ! /usr/bin/ping -c 1 $NAS_IP_INT > /dev/null; then
	PROFILE=ext
else
	PROFILE=int
fi

echo "Setting Profile to $PROFILE" >> /tmp/unison_startup.log 2>&1

sed -i "1s/.*/active_sync/" $STATE_FILE
sync documents_$PROFILE
sed -i "1s/.*/idle/" $STATE_FILE
