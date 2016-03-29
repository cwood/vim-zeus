" Vim syntax file
" Language: Zeus Traffic Manager TrafficScript
" Maintainer: Gaurav Ghildyal
" Latest Revision: 10 Oct 2009

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Read the C syntax to start with
if version < 600
  so <sfile>:p:h/perl.vim
else
  runtime! syntax/perl.vim
  unlet b:current_syntax
endif

syn keyword ztsStatement	array hash string
syn keyword ztsNoStatement      log exists	
hi def link ztsStatement	Statement
hi def link ztsNoStatement	None

let b:current_syntax = "zts"
