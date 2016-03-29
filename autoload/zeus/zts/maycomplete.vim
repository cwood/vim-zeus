" maycomplete.vim : Script containing autocomplete for Zeus TrafficScript functions.
" Version : 1.0
" License : TODO

function! s:CanComplete()
    return (index(['zts'], &filetype)>=0 && &omnifunc == 'zeus#zts#complete#Main' && !zeus#zts#utils#IsCursorInCommentOrString())
endfunc

function! zeus#zts#maycomplete#Dot()
   if s:CanComplete() && g:ZeusZTS_MayCompleteDot
      let ZeusMapping = "\<C-X>\<C-O>"
      return '.'.ZeusMapping
   else
      return '.'
   endif
endfunc
