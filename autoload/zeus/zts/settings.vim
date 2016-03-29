" settings.vim : Script containing auto completion for Zeus TrafficScript functions.
" Version : 1.0
" License : TODO

function! zeus#zts#settings#Init()
    " Set MayComplete to '.'
    "   0 = disabled
    "   1 = enabled
    "   default = 1
    if !exists('g:ZeusZTS_MayCompleteDot')
        let g:ZeusZTS_MayCompleteDot = 1
    endif

    " Should preview window be closed on closing brace?
    "   0 = No
    "   1 = Yes
    "   default = 1
    if !exists('g:ZeusZTS_AutoClosePreview')
        let g:ZeusZTS_AutoClosePreview = 1
    endif
endfunc
