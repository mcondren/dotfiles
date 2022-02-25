set termguicolors

"automated installation of vimplug if not installed
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source ~/.config/nvim/init.vim
endif

call plug#begin()

" plugins here
" Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Plug 'glepnir/lspsaga.nvim'
Plug 'jiangmiao/auto-pairs'
Plug 'machakann/vim-sandwich'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'gruvbox-community/gruvbox'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'yggdroot/indentline'
Plug 'dense-analysis/ale'
Plug 'tpope/vim-commentary'

call plug#end()

autocmd vimenter * colorscheme gruvbox
let g:airline_theme = 'gruvbox'

" Tabs and spaces
autocmd VimEnter * AirlineRefresh

set tabstop=2 softtabstop=2 shiftwidth=2 expandtab autoindent
" aesthetic
set relativenumber
set showmatch
set ignorecase
set smartcase
set gdefault

" show a few lines below the current line
set scrolloff=3

" Decrease dead time after ESC key
set ttimeout
set ttimeoutlen=50

" key mapping
let mapleader="\<SPACE>"
nnoremap <leader>vs :vnew<CR>:Files<CR>
nnoremap <silent> <CR> :nohlsearch<CR>
nnoremap <Leader>r :%s///g<Left><Left><left>
nnoremap <leader>gc :windo Gw<CR>:Gcommit<CR>
nnoremap <leader>gp :Gpush<CR>
nnoremap <A-down> :m+<CR>==
nnoremap <A-up> :m-2<CR>==
nnoremap <A-left> <<
nnoremap <A-right> >>
inoremap <A-down> <Esc>:m+<CR>==gi
inoremap <A-up> <Esc>:m-2<CR>==gi
inoremap <A-left> <Esc><<`]a
inoremap <A-right> <Esc>>>`]a
vnoremap <A-down> :m'>+<CR>gv=gv
vnoremap <A-up> :m-2<CR>gv=gv
vnoremap <A-left> <gv
vnoremap <A-right> >gv
nnoremap <C-up> <C-W><C-J>
nnoremap <C-down> <C-W><C-K>
nnoremap <C-right> <C-W><C-L>
nnoremap <C-left> <C-W><C-H>

let g:indentLine_char = '⦙'
