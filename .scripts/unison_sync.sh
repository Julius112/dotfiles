#!/bin/bash

STATE_FILE=$HOME/.unison/status
NAS_IP_INT="192.168.4.112"

/usr/bin/keychain $HOME/.ssh/id_ed25519
source $HOME/.keychain/$HOSTNAME-sh
ssh-add -l
if [[ $? -ne 0 ]]; then
	exit
fi

if ! /usr/bin/ping -c 1 $NAS_IP_INT > /dev/null; then
	LOC=ext
else
	LOC=int
fi

PROFILE=$1_$LOC

echo "Setting Profile to $PROFILE"

echo "Creating Snapshot prior to Sync..."
$HOME/.scripts/snapshot.sh

for i in `seq 1 2`; do
	sed -i "1s/.*/active_sync/" $STATE_FILE
	/opt/bin/unison $PROFILE -ignore 'Path E-Mail/Thunderbird_Profile' -ignore 'Name {*/,.*/}.git' -ignore 'Name *.o' -ignore 'Name *.a' -ignore 'Name *.obj' -ignore 'Name popstate.dat' $2
	if [ $? -ne 0 ]; then
		sed -i -e "s/$1=./$1=0/g" $STATE_FILE
		sed -i "1s/.*/active_sync/" $STATE_FILE
	else
		sed -i -e "s/$1=./$1=1/g" $STATE_FILE
		break
	fi
	sleep 600
done
sed -i "1s/.*/idle/" $STATE_FILE
