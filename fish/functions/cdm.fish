function cdm
	cd $HOME/media/music/(mpc -f '%file%' | string split '/' | head -n 2 | string join '/')
end
