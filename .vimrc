filetype plugin on
filetype indent on
syntax on
set autoindent
set mouse=a

set background=dark
set t_Co=256

set tabstop=2
set shiftwidth=2
set expandtab

set colorcolumn=80

set nocompatible

set foldmethod=syntax

let g:colorizer_auto_filetype='css,html'
let Tlist_Auto_Open = 1
let Tlist_Exit_OnlyWindow = 1
nnoremap <silent> <F8> :TlistToggle<CR>
nnoremap <silent> <F3> :set spell spelllang=en_us<CR>
nnoremap <silent> <F4> :set spell&<CR>
"asetlocal spell spelllang=en_us

augroup JumpCursorOnEdit
 au!
 autocmd BufReadPost *
 \ if expand("<afile>:p:h") !=? $TEMP |
 \ if line("'\"") > 1 && line("'\"") <= line("$") |
 \ let JumpCursorOnEdit_foo = line("'\"") |
 \ let b:doopenfold = 1 |
 \ if (foldlevel(JumpCursorOnEdit_foo) > foldlevel(JumpCursorOnEdit_foo - 1)) |
 \ let JumpCursorOnEdit_foo = JumpCursorOnEdit_foo - 1 |
 \ let b:doopenfold = 2 |
 \ endif |
 \ exe JumpCursorOnEdit_foo |
 \ endif |
 \ endif |
 \ autocmd BufWinEnter *
 \ if exists("b:doopenfold") |
 \ exe "normal zv" |
 \ if(b:doopenfold > 1) |
 \ exe "+".1 |
 \ endif |
 \ unlet b:doopenfold |
 \ endif
augroup END

