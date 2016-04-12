function man
	vim -c "SuperMan $argv"
	
	if test $status -ge 1
 		echo "No manual entry for $argv"
	end
end
