#!/bin/bash

# TODO: add failed notification
# TODO: Add nothing to update notification
# TODO: Fix grep error when seatch two packages with -l
# TODO: Add no packages found to -s

while [[ $# -gt 0 ]]; do
	case "$1" in
		-h|--help)
			echo "-h         help"
			echo " + pkg     install"
			echo " - pkg     uninstall"
			echo "-u         update"
			echo "-c         clean"
			echo "-s pkg     search"
			echo "-l pkg     search local"
			echo "-i pkg     info"
			exit
			;;
		+)
			shift
			if [[ $# -ge 1 ]]; then
				pacaur -S $@
				if [[ $? -eq 0 ]]; then
					bash $SCRIPTS/notify/arya_install.sh $@ & disown
				fi
				exit
			else
				echo "No packages provided."
				exit
			fi
			shift
			;;
		-)
			shift
			if [[ $# -ge 1 ]]; then
				pacaur -Rs $@
				if [[ $? -eq 0 ]]; then
					bash $SCRIPTS/notify/arya_uninstall.sh $@ & disown
				fi
				exit
			else
				echo "No packages provided."
				exit
			fi
			shift
			;;
		-u)
			pacaur -Syyu
			if [[ $? -eq 0 ]]; then
				bash $SCRIPTS/notify/arya_update.sh & disown
			fi
			exit
			;;
		-c)
			if [[ -z $(pacaur -Qdtq) ]]; then
				echo "No orphaned packages found."
				exit
			else
				pacaur -Qdtq | pacaur -Rs -
				exit
			fi
			exit
			;;
		-s)
			shift
			if [[ $# -ge 1 ]]; then
				pacaur -Ss $@
				exit
			else
				echo "No search terms provided."
				exit
			fi
			shift
			;;
		-l)
			shift
			if [[ $# -ge 1 ]]; then
				list=$(pacaur -Q | grep $@)
				if [[ -n $list ]]; then
					pacaur -Qss $@
					exit
				else
					echo "Package not installed."
					exit
				fi
			else
				echo "No search terms provided."
				exit
			fi
			shift
			;;
		-i)
			shift
			if [[ $# -ge 1 ]]; then
				pacaur -Si $@
				exit
			else
				echo "No search terms provided."
				exit
			fi
			shift
			;;
		*)
			echo "Invalid option, use -h for help."
			exit
			;;
	esac
done

if [[ $# -eq 0 ]]; then
	echo "No option provided, use -h for help."
fi
