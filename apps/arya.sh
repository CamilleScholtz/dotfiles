#!/bin/bash

# TODO: add failed notification

options="--alphabetical --ask --color y --nospinner --tree"

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
			exit 0
			;;
		-i)
			shift
			if [[ $# -ge 1 ]]; then
				sudo emerge $options $@
				if [[ $? -eq 0 ]]; then
					bash $HOME/.scripts/notify/arya_install.sh $@ & disown
				fi
			else
				echo "No packages provided."
				exit 1
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
			else
				echo "No packages provided."
				exit 1
			fi
			shift
			;;
		-u)
			sudo emerge $options --update --newuse --deep @world
			if [[ $? -eq 0 ]]; then
				bash $HOME/.scripts/notify/arya_update.sh & disown
			fi
			exit 0
			;;
		-U)
			sudo emerge $options --sync
			if [[ $? -eq 0 ]]; then
				bash $HOME/.scripts/notify/arya_update.sh & disown
			fi
			exit 0
			;;
		-Uu)
			sudo emerge $options --sync && sudo emerge $options --update --newuse --deep @world
			if [[ $? -eq 0 ]]; then
				bash $HOME/.scripts/notify/arya_update.sh & disown
			fi
			exit 0
			;;
		-c)
			sudo emerge $options --depclean
			exit 0
			;;
		-C)
			sudo emerge $options --depclean --with-bdeps n && sudo eclean --destructive distfiles && sudo eclean --destructive packages
			exit 0
			;;
		-s)
			shift
			if [[ $# -ge 1 ]]; then
				emerge $options --search $@
			else
				echo "No search terms provided."
                                exit 1
                        fi
                        shift
			;;
		-S)
			shift
			if [[ $# -ge 1 ]]; then
				equery b $@
			else
				echo "No search terms provided."
				exit 1
			fi
			shift
			;;
		-f)
			shift
			if [[ $# -ge 1 ]]; then
				equery u $@
			else
				echo "No search terms provided."
				exit 1
			fi
			shift
			;;
		-d)
			shift
			if [[ $# -ge 1 ]]; then
				equery g $@
			else
				echo "No search terms provided."
				exit 1
			fi
			shift
			;;
		-e)
			sudo $EDITOR /etc/portage/package.use
			exit 0
			;;
		-E)
			sudo $EDITOR /etc/portage/make.conf
			exit 0
			;;
		*)
			echo "Invalid option, use -h for help."
			break
			;;
	esac
done

if [[ $# -eq 0 ]]; then
	echo "No option provided, use -h for help."
fi