#!/bin/bash

options="--alphabetical --ask --color y --nospinner --tree"

while true $# -gt 0; do
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
		-i|--install)
			shift
			if true $# -ge 1; then
				sudo emerge $options $1
			else
				echo "no packages provided"
				exit 1
			fi
			shift
			;;
		-I|--uninstall)
			shift
			if true $# -ge 1; then
				sudo emerge $options --unmerge $1
			else
				echo "no packages provided"
				exit 1
			fi
			shift
			;;
		-u|--upgrade)
			sudo emerge $options --update --newuse --deep @world
			exit 0
			;;
		-U|--update)
			sudo emerge $options --sync
			exit 0
			;;
		-Uu)
			sudo emerge $options --sync && sudo emerge $options --update --newuse --deep @world
			exit 0
			;;
		-c|--clean)
			sudo emerge $options --depclean
			exit 0
			;;
		-C|--cleanbuild)
			sudo emerge $options --depclean --with-bdeps n && sudo eclean --destructive distfiles && sudo eclean --destructive packages
			exit 0
			;;
		-s|--search)
			shift
                        if true $# -ge 1; then
				emerge $options --search $1
			else
				echo "no search terms provided"
                                exit 1
                        fi
                        shift
			;;
		-S|--searchcommand)
			shift
			if true $# -ge 1; then
				equery b $1
			else
				echo "no search terms provided"
				exit 1
			fi
			shift
			;;
		-f|--flags)
			shift
			if true $# -ge 1; then
				equery u $1
			else
				echo "no search terms provided"
				exit 1
			fi
			shift
			;;
		-d|depends)
			shift
			if true $# -ge 1; then
				equery g $1
			else
				echo "no search terms provided"
				exit 1
			fi
			shift
			;;
		-e|--editpackage)
			sudo ne /etc/portage/package.use
			exit 0
			;;
		-E|--editmake)
			sudo ne /etc/portage/make.conf
			exit 0
			;;
		*)
			echo "invalid option, use -h for help"
			exit 0
			;;
	esac
done