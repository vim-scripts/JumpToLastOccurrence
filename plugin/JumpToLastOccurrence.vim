" JumpToLastOccurrence.vim: f{char} motions that count from the end of the line.
"
" DEPENDENCIES:
"   - JumpToLastOccurrence.vim autoload script.
"
" Copyright: (C) 2010-2014 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.20.005	15-Jan-2014	Remove <Plug>JumpToLastOccurrenceReinsert
"				special mapping; now proved by the ingo-library.
"   1.20.004	14-Jan-2014	ENH: Implement repeat of operator-pending
"				mapping without re-querying the {char}.
"				Define an additional
"				JumpToLastOccurrenceRepeat_... omap and pass
"				this to JumpToLastOccurrence#Jump() in
"				operator-pending mode.
"				Add <silent> to <Plug>-mappings.
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
	    execute printf('%snoremap <silent> %s :<C-u>call JumpToLastOccurrence#Jump(%s, %d, %d%s)<CR>',
	    \	l:mode,
	    \	l:targetMapping,
	    \	string(l:mode),
	    \	(l:motion =~? 't'),
	    \	(l:motion =~# '\u'),
	    \   (l:mode ==# 'o' ? ', "\<lt>Plug>JumpToLastOccurrenceRepeat_' . l:motion . '"' : '')
	    \)
	    if ! hasmapto(l:targetMapping, l:mode)
		let l:mapping = g:JumpToLastOccurrence_Leader . l:motion
		execute (l:mode ==# 'v' ? 'x' : l:mode) . 'map <silent> ' . l:mapping . ' ' . l:targetMapping
	    endif

	    if l:mode ==# 'o'
		execute printf('%snoremap <silent> <Plug>JumpToLastOccurrenceRepeat_%s :<C-u>call JumpToLastOccurrence#Repeat(%s, %d, %d%s)<CR>',
		\   l:mode,
		\   l:motion,
		\   string(l:mode),
		\   (l:motion =~? 't'),
		\   (l:motion =~# '\u'),
		\   (l:mode ==# 'o' ? ', "\<lt>Plug>JumpToLastOccurrenceRepeat_' . l:motion . '"' : '')
		\)
	    endif
	endfor
    endfor
endfunction

call s:CreateMotionMappings()
delfunction s:CreateMotionMappings

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
