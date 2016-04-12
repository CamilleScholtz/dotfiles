function fish_prompt
	set_color $fish_color_cwd 
	echo (pwd | string replace $HOME '~')' '
end
