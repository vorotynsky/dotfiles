set nocompatible
filetype off

call plug#begin('~/.local/share/nvim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'rakr/vim-one'

Plug 'townk/vim-autoclose'
Plug 'preservim/nerdtree'
Plug 'neoclide/coc.nvim'

" Haskell
Plug 'ndmitchell/ghcid', { 'rtp': 'plugins/nvim' }
Plug 'neovimhaskell/haskell-vim'

" C++
Plug 'rip-rip/clang_complete'

call plug#end()

set noswapfile

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
  endif

" unicode symbols
"let g:airline#extensions#tabline#enabled = 1
let g:airline_left_sep = ''
let g:airline_right_sep = ''

let s:fontsize = 12

" colorscheme one
" set background=dark
" let g:airline_theme='one'

cnoreabbrev pt NERDTree


set tabstop=4
set shiftwidth=4
set smarttab
set expandtab
set smartindent

set number
set relativenumber

 noremap  <Up> ""
 noremap! <Up> <Esc>
 noremap  <Down> ""
 noremap! <Down> <Esc>
 noremap  <Left> ""
 noremap! <Left> <Esc>
 noremap  <Right> ""
 noremap! <Right> <Esc>


