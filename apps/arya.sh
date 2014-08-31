#!/bin/bash

# TODO: add failed notification

options="--alphabetical --ask --color y --nospinner"

while [[ $# -gt 0 ]]; do
	case "$1" in
		-h|--help)
			echo "-h         show help"
			echo "-i pkg     install"
			echo "-I pkg     uninstall"
			echo "-u         update/newuse @world"
			echo "-U         sync database"
			echo "-c         clean dependencies"
			echo "-C         clean dependencies and build-dependencies"
			echo "-s pkg     search"
			echo "-S pkg     search for file/command"
			echo "-f pkg     list USE flags"
			echo "-d pkg     list dependencies"
			echo "-e         edit package.use"
			echo "-E         edit make.conf"
			exit
			;;
		-i)
			shift
			if [[ $# -ge 1 ]]; then
				sudo emerge $options $@
				if [[ $? -eq 0 ]]; then
					bash $HOME/.scripts/notify/arya_install.sh $@ & disown
				fi
				exit
			else
				echo "No packages provided."
				exit
			fi
			shift
			;;
		-I)
			shift
			if [[ $# -ge 1 ]]; then
				sudo emerge $options --unmerge $@
				if [[ $? -eq 0 ]]; then
					bash $HOME/.scripts/notify/arya_uninstall.sh $@ & disown
				fi
				exit
			else
				echo "No packages provided."
				exit
			fi
			shift
			;;
		-u)
			sudo emerge $options --update --newuse --deep @world
			if [[ $? -eq 0 ]]; then
				bash $HOME/.scripts/notify/arya_update.sh & disown
			fi
			exit
			;;
		-U)
			sudo emerge $options --sync
			exit
			;;
		-Uu)
			sudo emerge $options --sync && sudo emerge $options --update --newuse --deep @world
			if [[ $? -eq 0 ]]; then
				bash $HOME/.scripts/notify/arya_update.sh & disown
			fi
			exit
			;;
		-c)
			sudo emerge $options --depclean
			exit
			;;
		-C)
			sudo emerge $options --depclean --with-bdeps n && sudo eclean --destructive distfiles && sudo eclean --destructive packages
			exit
			;;
		-s)
			shift
			if [[ $# -ge 1 ]]; then
				emerge $options --search $@
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
				equery b $@
				exit
			else
				echo "No search terms provided."
				exit
			fi
			shift
			;;
		-f)
			shift
			if [[ $# -ge 1 ]]; then
				equery u $@
				exit
			else
				echo "No search terms provided."
				exit
			fi
			shift
			;;
		-d)
			shift
			if [[ $# -ge 1 ]]; then
				equery g $@
				exit
			else
				echo "No search terms provided."
				exit
			fi
			shift
			;;
		-e)
			sudo $EDITOR /etc/portage/package.use
			exit
			;;
		-E)
			sudo $EDITOR /etc/portage/make.conf
			exit
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