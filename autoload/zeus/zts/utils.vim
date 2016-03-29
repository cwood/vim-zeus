" utils.vim : Script containing autocomplete for Zeus TrafficScript functions.
" Version : 1.0

function! zeus#zts#utils#TokenizeCurrentInstruction(line, cursor)
   let line = a:line
   let startPos = searchpos('[!(&;{}]\|\s', 'bWn', a:cursor[1]) 
   let endPos = a:cursor[2]
   let token = ''
   if line != ''
      let startPos[1] = (startPos[1]<=1)?0:startPos[1]
      let token = line[ startPos[1] : endPos ]
      " Trim spaces from beginning and end.
      let token = substitute( token, '[!(&;{}]\+', '', '' )
      let token = substitute( token, '^\s\+', '', '' )
      let token = substitute( token, '\s\+$', '', '' )
   endif
   return token
endfunc

function! zeus#zts#utils#closePreviewWindow()
   if g:ZeusZTS_AutoClosePreview
      return "\<Esc>\<C-W>\<C-Z>a)"
   else
      return ')'
   endif
endfunc

function! zeus#zts#utils#closePreviewWindowAlt()
   return "\<Esc>\<C-W>\<C-Z>"
endfunc

function! zeus#zts#utils#Smart_TabComplete()
   let substr = zeus#zts#utils#TokenizeCurrentInstruction(getline('.'), getpos('.'))
   if (strlen(substr)==0)                          " nothing to match on empty string
      return "\<tab>"
   endif
   let has_period = match(substr, '\.') != -1      " position of period, if any
   let has_slash = match(substr, '\/') != -1       " position of slash, if any
   let has_dollar = match(substr, '\$') != -1     " position of slash, if any
   let pum_visible = pumvisible()
   " If this a variable, then do file matching.
   if( has_dollar ) 
      return "\<C-X>\<C-P>"
   elseif (!has_period && !has_slash && !pum_visible)
      return "\<C-X>\<C-O>"                         " default to plugin matching
   elseif ( has_slash )
      return "\<C-X>\<C-F>"                         " can be used for TS libs.
   elseif ( pum_visible )
      return "\<C-X>\<C-O>"                         "TODO: Make more intuitive.	 		    
   else
      return "\<C-X>\<C-O>"                         " plugin matching
   endif
endfunction

function! zeus#zts#utils#ResolveFilePath(file)
    let result = ''
    let listPath = split(globpath(&path, a:file), "\n")
    if len(listPath)
       let result = listPath[0]
    endif
    return simplify(result)
endfunc

function! zeus#zts#utils#IsCursorInCommentOrString()
   " Check if the cursor is in comment - note that we are overriding perl syntax.
    return match(synIDattr(synID(line("."), col(".")-1, 1), "name"), 'perlComment\|perlString')>=0
endfunc
