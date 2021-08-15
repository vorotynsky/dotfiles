set nocompatible
" filetype off

call plug#begin('~/.local/share/nvim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'rakr/vim-one'

Plug 'townk/vim-autoclose'
Plug 'preservim/nerdtree'
Plug 'neoclide/coc.nvim', { 'do': { -> coc#util#install() } }
Plug 'tpope/vim-repeat'

" Haskell
Plug 'ndmitchell/ghcid', { 'rtp': 'plugins/nvim' }
Plug 'neovimhaskell/haskell-vim'
Plug 'twinside/vim-hoogle'

" C++
" clang_complete fails
" Plug 'rip-rip/clang_complete'
Plug 'vim-syntastic/syntastic'

" LaTeX
Plug 'lervag/vimtex'
call plug#end()


if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
if expand('%:t') == "COMMIT_EDITMSG"
    let g:airline#extensions#tabline#enabled = 0
else
    let g:airline#extensions#tabline#enabled = 1
endif
let g:airline_left_sep = ''
let g:airline_right_sep = ''

let s:fontsize = 12
let g:airline_theme='papercolor'

cnoreabbrev pt NERDTree

set noswapfile
set tabstop=4
set shiftwidth=4
set smarttab
set expandtab
set smartindent
set hidden
set mouse=a

set splitbelow
set splitright

set number
set relativenumber
set so=7

noremap <F5> :tabnew <Enter>
noremap <F6> :bprevious <Enter>
noremap <F7> :bnext <Enter>


" set keymap=russian-jcukenwin
" set iminsert=0
" set imsearch=0

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"
" Haskell
"
syntax on
filetype plugin indent on

let g:haskell_indent_if = 3
let g:haskell_indent_where = 6
let g:haskell_indent_before_where = 4
let g:haskell_indent_do = 3
let g:haskell_indent_before_where = 4
let g:haskell_indent_guard = 4

"
" C++
"

"let g:clang_library_path='/usr/lib/libclang.so'

" 
" LaTeX
"
let g:tex_flavour = 'latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'
hi Conceal ctermfg=909 ctermbg=909
 
function! Tex()
   execute "!pdflatex -synctex=1 -interaction=nonstopmode %:p > /dev/null"
    execute "!latexmk -c > /dev/null"
    execute "!rm %:r.synctex.gz"
endfunction

autocmd BufNewFile,BufRead *.tex abbr  f         :call Tex()         <CR>
autocmd BufNewFile,BufRead *.tex abbr wf :w <CR> :call Tex()         <CR>
autocmd BufNewFile,BufRead *.tex abbr ff         :!zathura %:r.pdf & <CR>
