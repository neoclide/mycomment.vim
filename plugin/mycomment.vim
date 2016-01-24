" ============================================================================
" Description: An easy comment plugin
" Author: Qiming Zhao <chemzqm@gmail.com>
" Licence: Vim licence
" Version: 0.2
" ============================================================================
if get(g:, "comment_loaded", 0)
  finish
endif
let g:comment_loaded = 1

let s:save_cpo = &cpo
set cpo&vim

vnoremap <silent> <leader>c :Comment<cr>
nnoremap <silent> <leader>c :<C-u>set operatorfunc=<SID>CommentFromSelected<cr>g@
nnoremap <silent> <leader>cc :<C-u>set opfunc=<SID>CommentFromSelected<Bar>exe 'normal! 'v:count1.'g@_'<CR>

let s:xmls = ['html', 'xhtml', 'xml']

function! s:CommentFromSelected(type, ...)
  let sel_save = &selection
  let &selection = "inclusive"
  if index(s:xmls, &ft) != -1 && exists('*emmet#toggleComment')
    call emmet#toggleComment()
    return
  endif
  let g:mode = a:type
  if a:0
    let start = line('v')
    let end = line('.')
    let g:start = start
    let g:end = end
  elseif a:type ==#'c'
    let start = line('.')
    let end = line('.')
  else
    normal! '[
    let start = line('.')
    normal! ']
    let end = line('.')
  endif
  call s:CommentLines(start, end)
  let &selection = sel_save
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
  elseif !a:hasComment
    let str = a:com_beg . a:line[a:min : ] . a:com_end
    if a:min | let str = a:line[0 : a:min - 1] . str | endif
  else
    let str = a:line
  endif
  return str
endfunction

function! s:CommentLines(start, end)
  let lines = []
  let indents = []
  let com_begin = get(s:comment_begin, &ft, '#')
  let com_end = get(s:comment_end, &ft, '')
  let hasComment = substitute(getline('.'), s:regex, '', '')[0 : len(com_begin) - 1] ==# com_begin ?
          \ 1 : 0
  for lnum in range(a:start, a:end)
    call add(indents, indent(lnum))
    call add(lines, getline(lnum))
  endfor
  let min_indent = min(indents)
  call map(lines, 's:CommentToggle(v:val, com_begin, com_end, hasComment, min_indent)')
  "echo len(lines)
  call setline(a:start, lines)
endfunction

command! -range=1 -nargs=0 Comment :call s:CommentLines(<line1>, <line2>)

let &cpo = s:save_cpo
unlet s:save_cpo
