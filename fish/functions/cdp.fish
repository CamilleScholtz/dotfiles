function cdp
	set location (prtl $argv)

	if test $status -eq 0
		cd $location
	else
		cd /usr/ports
	end
end
