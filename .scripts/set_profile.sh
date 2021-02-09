#!/usr/bin/bash

# setup profile
# TODO check monitor config
#if ! xrandr --listmonitors | grep "TODO" > /dev/null; then

#check the amount of connected displays and if its work, set the layout for work.
xrandr --auto
location=nied
mon=$(xrandr | grep " connected")
#if [[ $mon =~ "eDP-1" && $mon =~ "HDMI-1" ]]
if  [[ $mon =~ "eDP-1" && $mon =~ $'\nDP-1' ]]
then
	location=nied
	nmcli radio wifi on
#elif  [[ $mon =~ "eDP-1" && $mon =~ $'\nDP-1' ]]
#then
#	location=skillbyte
#	nmcli radio wifi off
else
	location=remote
	nmcli radio wifi on
fi

if [ -z ${var+x} ]; then

	# set screenlayout
	sh $HOME/.screenlayout/$location.sh > /dev/null 2>&1

	# set the right i3 config
	cp ~/.config/i3/config_default ~/.config/i3/config
	cat ~/.config/i3/config_$location >> ~/.config/i3/config
	cp ~/.config/i3/i3blocks/i3blocks_$location.conf ~/.config/i3/i3blocks/i3blocks.conf
	cp ~/.Xresources_$location ~/.Xresources
	xrdb -merge ~/.Xresources
	i3-msg restart > /dev/null 2>&1
	echo $location

	# save profile to be picked up by other programs
	echo $location > /tmp/.profile_location
else
	echo "no profile detected"
fi
