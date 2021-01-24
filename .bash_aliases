alias open='mimeo -q'

alias vi=vim

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ls='ls --color=auto'
alias ll='ls -lrtFh'
alias la='ls -alrtFh'

alias k='kubectl'
alias kns='kubectl config set-context --current --namespace='

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias off="$HOME/.scripts/unison_sync_all.sh; sudo shutdown now"
alias slp="$HOME/.scripts/unison_sync_all.sh; systemctl hybrid-sleep"
alias offon="sudo reboot now"
alias findn="find -name "

#git aliases
alias gs="git status"
alias gd="git diff"
alias gp="git push"


#sudo  aliases
alias pacman="sudo pacman"
alias mount="sudo mount -o uid=1000,gid=1000"
alias umount="sudo umount"

#latex aliases
alias tlmgr='/usr/share/texmf-dist/scripts/texlive/tlmgr.pl --usermode'

# thefuck
eval $(thefuck --alias)
alias f="fuck -y"


#scanning
#alias scan="DATE=`date +%Y_%m_%d` && hp-scan --device='hpaio:/net/Deskjet_2540_series?ip=192.168.4.26' --file=$DATE-"
scan() {
	NAME=$1
	if [ -z ${1+x} ]; then
		echo "no filename supplied"
		return -1
	fi
	if [ -z ${2+x} ]; then
		count=1
	else
		count=$2
	fi
	if [ -z ${HP_SCANNER+x} ]; then
		#HP_SCANNER="hpaio:/net/Deskjet_2540_series?ip=192.168.4.26"
		HP_SCANNER="hpaio:/net/Officejet_J4680_series?ip=192.168.4.110"
	fi
	DATE=`date +%Y_%m_%d`
	if [ $count -gt 1 ]; then
		for idx in $(seq 1 $count); do
			#hp-scan --resolution=200 --device=$HP_SCANNER --tlx=0 --tly=0 --brx=220 --bry=300 --mode=color --file="temp-$idx.pdf"
			hp-scan --resolution=200 --device=$HP_SCANNER --mode=color --size=a4 --adf --file="temp-$idx.pdf"
			if [ $idx -lt $count ]; then
				echo "Please insert next page and press ENTER to continue..."
				read -n 1
			fi
		done
		pdfunite temp-*.pdf "$DATE-$NAME.pdf"
		if [ $? -eq 0 ]; then
			rm temp-*.pdf
		fi
	else
		#hp-scan --resolution=200 --device=$HP_SCANNER --tlx=0 --tly=0 --brx=220 --bry=300 --mode=color --file="$DATE-$NAME.pdf"
		hp-scan --resolution=200 --device=$HP_SCANNER --mode=color --adf --size=a4 --file="$DATE-$NAME.pdf"
	fi
}
