#!/bin/bash

STATE_FILE=/home/julius/.unison/status
NAS_IP_INT=192.168.4.113

/usr/bin/keychain $HOME/.ssh/id_ed25519
source $HOME/.keychain/$HOSTNAME-sh
ssh-add -l > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
	exit
fi

if [[ $1 == familie ]]; then
	PROFILE=$1
else
	if ! ping -c 1 $NAS_IP_INT > /dev/null; then
		PROFILE=ext
	else
		PROFILE=int
	fi

	PROFILE=$1_$LOC
fi

echo "Setting Profile to $PROFILE"

for i in `seq 1 2`; do
	sed -i "1s/.*/active_sync/" $STATE_FILE
	/opt/bin/unison $PROFILE -silent=false -ignore 'Name panacea.dat' -ignore 'Name aborted-session-ping' $2
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
