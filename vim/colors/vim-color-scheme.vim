" Misc stuff
set background=dark

hi clear

if exists("syntax_on")
	syntax reset
endif

let g:colors_name = "custom"

" Colors
hi Normal		ctermfg=none			ctermbg=none
hi NonText		ctermfg=none
hi comment		ctermfg=8				ctermbg=none
hi constant		ctermfg=cyan
hi identifier	ctermfg=magenta
hi statement	ctermfg=darkcyan		ctermbg=none
hi preproc		ctermfg=green
hi type			ctermfg=blue			ctermbg=none
hi special		ctermfg=yellow			ctermbg=none
hi Underlined	ctermfg=blue			cterm=underline
hi label		ctermfg=cyan
hi operator		ctermfg=magenta			ctermbg=none

hi ErrorMsg		ctermfg=red				ctermbg=none
hi WarningMsg	ctermfg=red				ctermbg=none
hi ModeMsg		ctermfg=none
hi MoreMsg		ctermfg=none
hi Error		ctermfg=red				ctermbg=none

hi Todo			ctermfg=0 ctermbg=9
hi Cursor		ctermfg=0 ctermbg=8
hi Search		ctermfg=0 ctermbg=9
hi IncSearch	ctermfg=0 ctermbg=9
hi LineNr		ctermfg=0
hi SpecialKey	ctermfg=0
hi NonText		ctermfg=0
hi title		cterm=bold

hi VertSplit	ctermfg=blue	ctermbg=blue

hi CursorLine 	cterm=none ctermbg=none ctermfg=none
hi CursorLineNr cterm=none ctermbg=none ctermfg=8

hi Visual		term=reverse		ctermfg=white	ctermbg=0

hi DiffChange	ctermbg=darkGreen	ctermfg=black
hi DiffText		ctermbg=lightGreen	ctermfg=black
hi DiffAdd		ctermbg=blue		ctermfg=black
hi DiffDelete   ctermbg=cyan		ctermfg=black

hi Folded		ctermbg=yellow		ctermfg=black
hi FoldColumn	ctermbg=gray		ctermfg=black
hi cIf0			ctermfg=gray
