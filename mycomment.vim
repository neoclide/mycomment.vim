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

vnoremap <leader>c :call <SID>CommentFromSelected(visualmode(), 1)<cr>
nnoremap <leader>c :set operatorfunc=<SID>CommentFromSelected<cr>g@
nnoremap <leader>cc :<C-U>set opfunc=<SID>CommentFromSelected<Bar>exe 'norm! 'v:count1.'g@_'<CR>

let s:xmls = ['html', 'xhtml', 'xml']

function! s:CommentFromSelected(type, ...)
  if a:0
    let start = line('v')
    let end = line('.')
  elseif a:type ==#'c'
    let start = line('.')
    let end = line('.')
  else
    normal '[
    let start = line('.')
    normal! `]
    let end = line('.')
  endif
  if index(s:xmls, &ft) != -1
    call s:CommentXml(start, end)
  else
    call s:CommentLines(start, end)
  endif
endfunction

function! s:CommentXml(start, end)
  if !exists('*emmet#toggleComment')
    call s:CommentLines(a:start, a:end)
  else
    call emmet#toggleComment()
  endif
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
function! s:CommentToggle(lnum, com_beg, com_end)
  let line = getline(a:lnum)
  if (len(line) == 0) | return line | endif
  let indent = matchstr(line, s:regex)
  let sl = len(indent)
  if line[sl : len(a:com_beg) + sl -1] != a:com_beg
    let line = indent . a:com_beg . line[sl : ] . a:com_end
  else
    let line = indent . line[len(a:com_beg) + sl : len(line)-len(a:com_end)-1]
  endif
  return line
endfunction

function! s:CommentLines(start, end)
  let lines = []
  let com_begin = get(s:comment_begin, &ft, '#')
  let com_end = get(s:comment_end, &ft, '')
  for lnum in range(a:start, a:end)
    call add(lines, s:CommentToggle(lnum, com_begin, com_end))
  endfor
  call setline(a:start, lines)
endfunction


let &cpo = s:save_cpo
