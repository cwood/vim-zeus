" popup.vim : Script containing auto-complete for Zeus TrafficScript functions.
" Version : 1.0
" License : TODO

function! zeus#zts#popup#SetHeight()
   "Get current window height
   let height = winheight(0) - winline()
   silent! wincmd P
   if &previewwindow
      let height = winheight(0) - &previewheight - 2 
      wincmd p
   endif
   let &pumheight=height
endfunc

let s:IsPumVisible = 0
function! zeus#zts#popup#CursorUp()
  if pumvisible() && !s:IsPumVisible
     call zeus#zts#popup#SetHeight()
     let s:IsPumVisible = 1
  else
     let s:IsPumVisible = 0
  endif
  return "\<Up>"
endfunc

function! zeus#zts#popup#CursorDown()
  if pumvisible() && !s:IsPumVisible
     call zeus#zts#popup#SetHeight()
     let s:IsPumVisible = 1
  else
     let s:IsPumVisible = 0
  endif
  
  return "\<Down>"
endfunc

function! zeus#zts#popup#ConfigureMenu( num )
  if a:num == 1
     set completeopt-=menu
     if match( &completeopt, 'menuone' ) == -1 
        set completeopt+=menuone
     endif
  else
     set completeopt-=menuone
     if match( &completeopt, 'menu' ) == -1 
        set completeopt+=menu
     endif
  endif 
endfunc

