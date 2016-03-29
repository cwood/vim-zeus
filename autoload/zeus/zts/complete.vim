" complete.vim : Script containing autocomplete for Zeus TrafficScript functions.
" Version : 1.0
" License : TODO

" Check if already loaded.
if exists("zts_loaded")
   echo "already loaded"
   delfunction zeus#zts#complete#Main
endif
let zts_loaded=1

" Be forward compatible
let s:global_cpo = &cpo " store current compatible-mode  in local variable
set cpo&vim " go into nocompatible-mode

" Only runs on Unix systems.
if has("win16") || has("win32") || has("win64")|| has("win95")
   finish
endif

if ( v:version < 700 )
   echohl WarningMsg
   echomsg "zeus#zts#complete.vim: Please install vim 7.0 or higher for TrafficScript completion"
   echohl None
   finish
endif

let s:hasPreviewWindow = match(&completeopt, 'preview')>=0
let s:hasPreviewWindowOld = s:hasPreviewWindow
let &previewheight = winheight(0) * 30 / 100

call zeus#zts#functions#Init()
call zeus#zts#compile#Init()
call zeus#zts#settings#Init()

function! zeus#zts#complete#Init()
   set omnifunc=zeus#zts#complete#Main
   inoremap <expr> . zeus#zts#maycomplete#Dot()
   inoremap <expr> <Down> zeus#zts#popup#CursorDown() 
   inoremap <expr> <Up> zeus#zts#popup#CursorUp()
   inoremap <expr> ) zeus#zts#utils#closePreviewWindow()
   inoremap <expr> <C-P> zeus#zts#utils#closePreviewWindowAlt()
   inoremap <tab> <c-r>=zeus#zts#utils#Smart_TabComplete()<CR>
"   inoremap <F2> <c-r>=zeus#zts#utils#Smart_TabComplete()<CR>
endfunc

function! zeus#zts#complete#Main(findstart, base)
   if a:findstart
      " locate the start of the word
      let line = getline('.')
      let s:save_cursor = getpos('.')
      let s:save_line = getline('.')
      " only works for '.'s
      let start = col('.') - 1
      let lastword = -1
      while start > 0
	 if line[start - 1 ] =~ '[.!(&;{}]\|\s'
	    break
         elseif line[start - 1 ] =~ '\w'
            let start -= 1
	 else 
	    let start -= 1   "be safe
         endif 
      endwhile
      return start
   else
      let res = []
      let funcs = {}
      let code = zeus#zts#utils#TokenizeCurrentInstruction( s:save_line, s:save_cursor)
      if code == '.'
	 return funcs
      endif 
      let funcs = zeus#zts#functions#getFunctions(code)
      call zeus#zts#popup#ConfigureMenu( len( funcs ) )
      let dotidx = strridx( code, '.' )
      let object = ( dotidx != -1 ) ? strpart( code, 0, dotidx + 1 ) : code
      for name in sort( keys( funcs ) )
         let item = {}
         if funcs[name] == 1
           let funcdetails = zeus#zts#functions#getFunctionDetails( object.name )
           let item.word = name
           let item.abbr = name
           if !empty( funcdetails )
              let item.info = join( funcdetails.DESCRIPTION, "\n" )."\n\n"
              if has_key( funcdetails, 'PARAMETERS' ) 
                 let item.menu = funcdetails.PARAMETERS
                 let item.info = item.info."PARAMETERS: ".funcdetails.PARAMETERS."\n"
              endif
              let item.info = item.info."SAMPLE:\n".join( funcdetails.SAMPLE, "\n" )
           endif
         else
            let item.word = name
            let item.abbr = name
	    let funcname = ( dotidx != -1 ) ? object.name : name
            let item.info = "Uses: ".join( keys( zeus#zts#functions#getFunctions( funcname."." ) ), ', ' )
         endif
	 let item.icase = 1
         call add(res, item)
      endfor
      return res
   endif
endfunc

" Go back to the original compatibility mode.
let &cpo = s:global_cpo

