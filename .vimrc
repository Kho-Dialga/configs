" Plugins
call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline' " Statusline
Plug 'vim-airline/vim-airline-themes' " Themes for statusline
Plug 'scrooloose/nerdtree' " File Tree
Plug 'morhetz/gruvbox' " Color Scheme
Plug 'dense-analysis/ale' " Linter
Plug 'mattn/emmet-vim' " Emmet

call plug#end()

" Vim config
syntax on " Syntax highlighting
set encoding=utf-8 " Encoding
set guifont=Cascadia\ Code\ Medium\ 13 " Font
colorscheme "colors-wal" " Colorscheme
set background=dark " Set gruvbox to dark
set guioptions-=m " Hide Gvim Menubar
set autoindent
set number " Show Numbers

" Indentation
filetype plugin indent on
set tabstop=2
set shiftwidth=2
set expandtab
set autoindent

" Key mapping
map <C-b> :NERDTreeToggle<CR>

" Plugin config
let g:airline_powerline_fonts = 1 " Enable powerline
let g:airline_theme='gruvbox' " Statusline theme

" Open NERDTree if no file specified.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Open NERDTree on Opening Directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif

" Ale linter
let g:ale_linters = {
\   'javascript': ['standard'],
\}
let g:ale_fixers = {'javascript': ['standard']}
