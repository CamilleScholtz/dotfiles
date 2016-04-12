
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

if version < 600
  so <sfile>:p:h/sh.vim
else
  runtime! syntax/sh.vim
  unlet b:current_syntax
endif

syntax keyword shFunctionKey .
syntax keyword shFunctionKey alias
syntax keyword shFunctionKey and
syntax keyword shFunctionKey begin
syntax keyword shFunctionKey bg
syntax keyword shFunctionKey bind
syntax keyword shFunctionKey block
syntax keyword shFunctionKey break
syntax keyword shFunctionKey breakpoint
syntax keyword shFunctionKey builtin
syntax keyword shFunctionKey case
syntax keyword shFunctionKey cd
syntax keyword shFunctionKey command
syntax keyword shFunctionKey commandline
syntax keyword shFunctionKey complete
syntax keyword shFunctionKey contains
syntax keyword shFunctionKey continue
syntax keyword shFunctionKey count
syntax keyword shFunctionKey echo
syntax keyword shFunctionKey else
syntax keyword shFunctionKey emit
syntax keyword shFunctionKey end
syntax keyword shFunctionKey exec
syntax keyword shFunctionKey exit
syntax keyword shFunctionKey fg
syntax keyword shFunctionKey for
syntax keyword shFunctionKey function
syntax keyword shFunctionKey functions
syntax keyword shFunctionKey history
syntax keyword shFunctionKey if
syntax keyword shFunctionKey jobs
syntax keyword shFunctionKey not
syntax keyword shFunctionKey or
syntax keyword shFunctionKey pwd
syntax keyword shFunctionKey random
syntax keyword shFunctionKey read
syntax keyword shFunctionKey return
syntax keyword shFunctionKey set
syntax keyword shFunctionKey status
syntax keyword shFunctionKey switch
syntax keyword shFunctionKey test
syntax keyword shFunctionKey ulimit
syntax keyword shFunctionKey while

syntax keyword shFunctionKey in
