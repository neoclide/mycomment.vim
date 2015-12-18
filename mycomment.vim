" ============================================================================
" Description: An easy comment plugin
" Author: Qiming Zhao <chemzqm@gmail.com>
" Licence: Vim licence
" Version: 0.1
" ============================================================================
if exists("g:comment_loaded") && !exists("g:comment_debug")
  finish
endif
let g:comment_loaded = 1

let s:save_cpo = &cpo
set cpo&vim

vnoremap <silent> <leader>c :call <SID>CommentFromSelected(visualmode(), 1)<cr>
nnoremap <silent> <leader>c :set operatorfunc=<SID>CommentFromSelected<cr>g@
nnoremap <silent> <leader>cc :<C-U>set opfunc=<SID>CommentFromSelected<Bar>exe 'norm! 'v:count1.'g@_'<CR>

let s:xmls = ['html', 'xhtml', 'xml']

function! s:CommentFromSelected(type, ...)
  if index(s:xmls, &ft) != -1 && exists('*emmet#toggleComment')
    call emmet#toggleComment()
    return
  endif
  if a:0
    let start = line('v')
    let end = line('.')
  elseif a:type ==#'c'
    let start = line('.')
    let end = line('.')
  else
    normal! '[
    let start = line('.')
    normal! ']
    let end = line('.')
  endif
  let cur = getline('.')
  call s:CommentLines(start, end, cur)
endfunction

let s:comment_begin = {
      \"c"          : "/*",
      \"cpp"        : "//",
      \"css"        : "/*",
      \"default"    : "#",
      \"go"         : "//",
      \"java"       : "//",
      \"javascript" : "//",
      \"plaintex"   : "%",
      \"tex"        : "%",
      \"vim"        : "\"",
      \"markdown"   : "<!--",
      \"xhtml"      : "<!--",
      \"xml"        : "<!--",
      \"html"       : "<!--",
      \}

" (optional)
let s:comment_end = {
      \"c"          : "*/",
      \"css"        : "*/",
      \"default"    : "",
      \"xhtml"      : "-->",
      \"xml"        : "-->",
      \"html"       : "-->",
      \"markdown"   : "-->",
      \}

let s:regex = '^\s*'
function! s:CommentToggle(line, com_beg, com_end, hasComment, min)
  let indent = matchstr(a:line, s:regex)
  let sl = len(indent)
  let has = a:line[sl : len(a:com_beg) + sl - 1] ==# a:com_beg
  if a:hasComment && has
    let str = indent . a:line[len(a:com_beg) + sl : len(a:line)-len(a:com_end) - 1]
  elseif !a:hasComment && !has
    let str = a:com_beg . a:line[a:min : ] . a:com_end
    if a:min | let str = a:line[0 : a:min - 1] . str | endif
  else
    let str = a:line
  endif
  return str
endfunction

function! s:CommentLines(start, end, cur)
  let lines = []
  let com_begin = get(s:comment_begin, &ft, '#')
  let com_end = get(s:comment_end, &ft, '')
  let hasComment = substitute(a:cur, s:regex, '', '')[0 : len(com_begin) - 1] ==# com_begin ?
          \ 1 : 0
  let min = 20
  for lnum in range(a:start, a:end)
    let line = getline(lnum)
    if min > 0
      let sl = len(matchstr(line, s:regex))
      let min = sl > min ? min : sl
    endif
    call add(lines, line)
    "call add(lines, s:CommentToggle(lnum, com_begin, com_end))
  endfor
  call map(lines, 's:CommentToggle(v:val, com_begin, com_end, hasComment, min)')
  "echo len(lines)
  call setline(a:start, lines)
endfunction


let &cpo = s:save_cpo
