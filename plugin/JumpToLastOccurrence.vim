" JumpToLastOccurrence.vim: f{char} motions that count from the end of the line. 
"
" DEPENDENCIES:
"   - JumpToLastOccurrence.vim autoload script. 
"
" Copyright: (C) 2010 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS 
"   1.10.003	30-Dec-2010	Moved functions from plugin to separate autoload
"				script. 
"				Made mappings configurable. 
"   1.00.002	29-Dec-2010	Reviewed for release. 
"	001	11-Dec-2010	file creation

" Avoid installing twice or when in unsupported Vim version. 
if exists('g:loaded_JumpToLastOccurrence') || (v:version < 700)
    finish
endif
let g:loaded_JumpToLastOccurrence = 1

let s:save_cpo = &cpo
set cpo&vim

"- configuration --------------------------------------------------------------
if ! exists('g:JumpToLastOccurrence_Leader')
    let g:JumpToLastOccurrence_Leader = ','
endif


"- mappings -------------------------------------------------------------------
function! s:CreateMotionMappings()
    for l:mode in ['n', 'o', 'v']
	for l:motion in ['f', 'F', 't', 'T']
	    let l:targetMapping = '<Plug>JumpToLastOccurrence_' . l:motion
	    execute printf('%snoremap %s :<C-u>call JumpToLastOccurrence#Jump(%s, %d, %d)<CR>',
	    \	l:mode,
	    \	l:targetMapping,
	    \	string(l:mode),
	    \	(l:motion =~? 't'),
	    \	(l:motion =~# '\u')
	    \)
	    if ! hasmapto(l:targetMapping, l:mode)
		let l:mapping = g:JumpToLastOccurrence_Leader . l:motion
		execute (l:mode ==# 'v' ? 'x' : l:mode) . 'map <silent> ' . l:mapping . ' ' . l:targetMapping 
	    endif
	endfor
    endfor
endfunction

call s:CreateMotionMappings()
delfunction s:CreateMotionMappings

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
