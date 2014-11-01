#!/bin/bash

# TODO: add failed notification
# TODO: Add nothing to update notification
# TODO: Fix grep error when seatch two packages with -l
# TODO: Add no packages found to -s

if [[ $# -ge 1 ]]; then
	case "$1" in
		-h|--help)
			echo "-h         help"
			echo "-c         clean"
			echo "-s pkg     search"
			echo "-S pkg     search local"
			echo "-i pkg     info"
			echo " + pkg     install"
			echo " - pkg     uninstall"
			echo "           update"
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
		-S)
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
		+)
			shift
			if [[ $# -ge 1 ]]; then
				pacaur -S $@
				if [[ $? -eq 0 ]]; then
					bash $SCRIPTS/notify/aiko_install.sh $@ & disown
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
					bash $SCRIPTS/notify/aiko_uninstall.sh $@ & disown
				fi
				exit
			else
				echo "No packages provided."
				exit
			fi
			shift
			;;
		*)
			echo "Invalid option, use -h for help."
			exit
			;;
	esac
else
	pacaur -Syyu
	if [[ $? -eq 0 ]]; then
		bash $SCRIPTS/notify/aiko_update.sh & disown
		fi
	exit
fi
