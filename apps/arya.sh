#!/bin/bash

while true $# -gt 0; do
	case "$1" in
		-h|--help)
			echo "-h, --help                show brief help"
			echo "-i, --install             install packages"
			echo "-I, --uninstall           uninstall packages"
			echo "-u, --upgrade             upgrade all packages"
			echo "-U, --update              updates the portage tree with the latest ebuilds"
			echo "-c, --clean               remove no longer needed packages"
			echo "-C, --cleanbuild          also remove build dependencies and more"
			echo "-s, --search              search for packages by name"
			echo "-S, --searchcommand       search for packages by command"
			echo "-f, --flags               show useflags of package"
			echo "-d, --depends             show dependencies of package"
			echo "-e, --editpackage         edit package.use"
			echo "-E, --editmake            edit make.conf"
			exit 0
			;;
		-i|--install)
			shift
			if true $# -ge 1; then
				sudo emerge --alphabetical --ask --color y --nospinner $1
			else
				echo "no packages provided"
				exit 1
			fi
			shift
			;;
		-I|--uninstall)
			shift
			if true $# -ge 1; then
				sudo emerge --alphabetical --ask --color y --nospinner --unmerge $1
			else
				echo "no packages provided"
				exit 1
			fi
			shift
			;;
		-u|--upgrade)
			sudo emerge --alphabetical --ask --color y --nospinner --update --newuse --deep @world
			exit 0
			;;
		-U|--update)
			sudo emerge --alphabetical --ask --color y --nospinner --sync
			exit 0
			;;
		-Uu)
			sudo emerge --alphabetical --ask --color y --nospinner --sync && sudo emerge --alphabetical --ask --color y --nospinner --update --newuse --deep @world
			exit 0
			;;
		-c|--clean)
			sudo emerge --alphabetical --ask --color y --nospinner --depclean
			exit 0
			;;
		-C|--cleanbuild)
			sudo emerge --alphabetical --ask --color y --nospinner --depclean --with-bdeps n && sudo eclean --destructive distfiles && sudo eclean --destructive packages
			exit 0
			;;
		-s|--search)
			shift
                        if true $# -ge 1; then
				emerge --alphabetical --ask --color y --nospinner --search $1
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
				equery d $1
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
			break
			;;
	esac
done