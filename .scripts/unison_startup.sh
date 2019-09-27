#!/bin/bash

STATE_FILE=/home/julius/.unison/status

/usr/bin/keychain $HOME/.ssh/id_ed25519
source $HOME/.keychain/$HOSTNAME-sh
ssh-add -l > /dev/null 2>&1
while [[ $? -ne 0 ]]; do
	sed -i "1s/.*/active_wait/" $STATE_FILE
	sleep 300
	/usr/bin/keychain $HOME/.ssh/id_ed25519
	source $HOME/.keychain/$HOSTNAME-sh
	ssh-add -l > /dev/null 2>&1
done

/home/julius/.scripts/unison_sync.sh documents
/home/julius/.scripts/unison_sync.sh music
/home/julius/.scripts/unison_sync.sh videos
/home/julius/.scripts/unison_sync.sh pictures
