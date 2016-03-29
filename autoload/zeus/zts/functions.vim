" functions.vim : Script containing auto-complete for Zeus TrafficScript functions.
" Version : 1.0

function! zeus#zts#functions#Init()
   let s:ruleFile = s:getRuleFile()
   let s:parsed = 0 
   let s:fTime = getftime( s:ruleFile ) 
   let s:functions = {}
   let s:levelOneFuncs ={} 
   let s:levelTwoFuncs = {}
   let s:levelThreeFuncs = {} 
   let s:funcidx = [ s:levelOneFuncs, s:levelTwoFuncs, s:levelThreeFuncs ]
   call s:ParseRuleFile()
endfunc

function s:getRuleFile()
   let listPath = split(globpath(&rtp, "autoload/zeus/zts/functions.txt"), "\n")
   let result = ''
   if len(listPath)
      let result = listPath[0]
   endif
   return simplify( result )
endfunc

function s:ParseRuleFile()
   if s:ruleFile == ''
      return 
   endif
   
   
   let newfTime = getftime( s:ruleFile )
   if s:parsed && s:fTime == newfTime
      return
   endif

   let s:cachedFile = readfile( s:ruleFile )
   
   let l:funcdet = {}
   let l:items = []
   let l:funcname = ""
   let l:state = ""
   for line in s:cachedFile 
      if line =~ '^TITLE:\s\.*'
         let l:funcname = split(line, ': ', 1)[1]
         call s:addTokens( l:funcname )
      elseif line =~ '^DESCRIPTION:\s\.*'
         let l:state = 'desc'
         let l:items = split(line, ': ', 1)
         let l:funcdet[l:items[0]] = [ l:items[1] ]
      elseif line =~ '^SAMPLE:\s\.*'
         let l:state = 'sample'
         let l:items = split(line, ':', 1)
         let l:funcdet[l:items[0]] = [ l:items[1] ]
      elseif line =~ '^PARAMETERS:\s\.*'
         let l:items = split(line, ':', 1)
         let l:funcdet[l:items[0]] = l:items[1]
      elseif line =~ '\w\+\|\S\+' 
         if l:state =~ 'desc' 
            call add( l:funcdet.DESCRIPTION, line )
         elseif l:state =~ 'sample'
            call add( l:funcdet.SAMPLE, line )
         endif
      else
         let s:functions[l:funcname] = l:funcdet
         let l:funcdet = {}
         let l:items = []
         let l:funcname = ""
         let l:state = ''
      endif  
   endfor
   let s:parsed = 1
endfunc

function s:sortFunctionList()
   for i in range(0, 2)
      call sort( keys( s:funcidx[i] ) )
   endfor
endfunc

function s:addTokens( fname )
   let l:tokens = []
   let l:tokens = split( a:fname, '\.' )
   let l:idx = 0
   let l:token = ""
   for item in l:tokens
     if l:idx > 0
        let l:token = l:token.".".item
     else 
        let l:token = item
     endif
     let s:funcidx[l:idx][l:token] = item 
     let l:idx = l:idx + 1
   endfor
endfunc

function zeus#zts#functions#getFunctionDetails(function)
   call s:RefreshFunctions()
   if has_key( s:functions, a:function )
      return s:functions[a:function]
   else
      return {}
   endif
endfunc

function zeus#zts#functions#getFunctions(name)
   if s:ruleFile == ''
      echohl WarningMsg
      echomsg "No Rules file"
      echohl None
      return {}
   endif
   if !len( a:name )
      let l:matches = {}
      for func in keys( s:funcidx[0] ) 
         let l:matches[s:funcidx[0][func]] = 0
      endfor
      return l:matches
   endif

   let l:tokens = split( a:name, '\.' )
   let l:tokens = matchlist( a:name, '\v(\.)\w+(\.)|\v(\.)' )
   let l:count = s:countChars( l:tokens[1:], '.' )
   let res = s:getTokens( a:name, l:count )
   return res 
endfunc

function s:countChars( tokens, char )
   let l:count = 0
   for item in a:tokens
      if item =~ a:char
         let l:count = l:count + 1
      endif
   endfor
   return l:count
endfunc

function s:getTokens(token, level)
   call s:RefreshFunctions()
   let l:matches = {}
   let token = substitute( a:token, '\.$', '\\.', '' )
   for func in sort( keys( s:funcidx[a:level] ) )
     let l:mstr = matchstr( func, token )
     if l:mstr != '' 
       " Only support of 3 levels, no more TODO: Make this generic.
       if a:level == 1 && match( keys( s:funcidx[a:level + 1] ), "^".func ) == -1
          let l:matches[s:funcidx[a:level][func]] = 1
       elseif a:level == 2
          let l:matches[s:funcidx[a:level][func]] = 1
       else
          let l:matches[s:funcidx[a:level][func]] = 0
       endif
       
     endif
   endfor
   return l:matches
endfunc

function s:RefreshFunctions()
   let l:newTime = getftime(s:ruleFile)
   if s:fTime != l:newTime
      let s:fTime = l:newTime
      let s:cachedFile = readfile(s:ruleFile)
      call s:ParseRuleFile( s:cachedFile )
   endif
endfunc
