#!/usr/bin/bash

# setup profile
# TODO check monitor config
#if ! xrandr --listmonitors | grep "TODO" > /dev/null; then

#check the amount of connected displays and if its work, set the layout for work.
xrandr --auto
location=nied
noconnected=$(xrandr | grep " connected" | wc -l)
case "$noconnected" in 
	1)
		location=remote
		;;
	2)
		location=home
		;; 
	3)
		location=nied
		;; 
esac

if [ -z ${var+x} ]; then

	# set screenlayout
	sh ~/.screenlayout/$location.sh > /dev/null 2>&1

	# set the right i3 config
	cp ~/.config/i3/config_$location ~/.config/i3/config
	cat ~/.config/i3/config_default >> ~/.config/i3/config
	cp ~/.config/i3/i3blocks/i3blocks_$location.conf ~/.config/i3/i3blocks/i3blocks.conf
	i3-msg restart > /dev/null 2>&1
	echo $location

	# save profile to be picked up by other programs
	echo $location > /tmp/.profile_location
else
	echo "no profile detected"
fi
