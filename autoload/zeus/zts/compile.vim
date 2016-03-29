" compile.vim : Script containing auto completion for Zeus TrafficScript functions.
" Version : 1.0
" License : TODO

function! zeus#zts#compile#Init()
   " F5 to compile rules in both insert and normal modes.
   noremap <expr> <F5> zeus#zts#compile#runZCLI()
   inoremap <F5> <C-R>=zeus#zts#compile#runZCLI()<CR>
   let s:isPathSet = 1
   call s:setPath()
endfunc

function s:setPath()
" see if ZEUSHOME is set.
if !$ZEUSHOME && !executable( $ZEUSHOME."/zxtm/bin/zeus.zxtm" )
   let s:isPathSet = 0
endif
endfunc

function! zeus#zts#compile#runZCLI()
   call s:setPath()
   let bufferName = getreg("%")
   let filePath = zeus#zts#utils#ResolveFilePath(bufferName)
   let filePath = (filePath=='')? bufferName : filePath
   if s:isPathSet
      echo system( "sudo $ZEUSHOME/zxtm/bin/zcli --formatoutput", "rule check ".filePath )
   
   else 
      echohl WarningMsg
      echomsg "Please set ZEUSHOME to compile rules"
      echohl None
   endif
endfunc

