#!/bin/bash

STATE_FILE=/home/julius/.unison/status

/usr/bin/keychain $HOME/.ssh/id_ed25519
source $HOME/.keychain/$HOSTNAME-sh
ssh-add -l > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
	exit
fi

for i in `seq 1 2`; do
	sed -i "1s/.*/active_sync/" $STATE_FILE
	/usr/local/bin/unison $1 -ignore 'Name panacea.dat' -ignore 'Name aborted-session-ping' $2
	if [ $? -ne 0 ]; then
		sed -i -e "s/$1=./$1=0/g" $STATE_FILE
		sed -i "1s/.*/active_sync/" $STATE_FILE
	else
		sed -i -e "s/$1=./$1=1/g" $STATE_FILE
		break
	fi
	sleep 20
done
sed -i "1s/.*/idle/" $STATE_FILE
