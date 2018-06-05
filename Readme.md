# Mycomment

[![](http://img.shields.io/github/issues/neoclide/mycomment.vim.svg)](https://github.com/neoclide/mycomment.vim/issues)
[![](http://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![](https://img.shields.io/badge/doc-%3Ah%20mycomment.txt-red.svg)](doc/mycomment.txt)

**DEPRECATED**

_A stupid comment plugin made for people can't remember so many mappings:)_

You only need to remember one mapping for comment:  `<leader>c`

## Install

Use your favourite plugin manager add something like `Bundle 'chemzqm/mycomment.vim'`

## API

### [count]\<leader\>cc

Toggle comment of `count`(default current line) lines.

### \<leader\>cip

Toggle comment of a block. Yes, it's a motion mapping, `ip` could be any motion object.

### V\*\*\*\<leader\>c

Select a block and toggle comment

## More productive

You can use `.` to repeat your last comment command, no need [vim-repeat](https://github.com/tpope/vim-repeat).

If you have [emmet-vim](https://github.com/mattn/emmet-vim), the plugin would use emmet comment function for comment toggle of tags in html/xml/xhtml files

## LICENSE

MIT
