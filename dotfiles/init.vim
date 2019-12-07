"General
syntax on
set number
set relativenumber
set nocompatible
set wrap
set ruler
set mouse=a

"Remapping
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
map ; :Files<CR>

"Plugins
call plug#begin('~/.local/share/nvim/plugged')

"General
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'tpope/vim-surround'
Plug 'terryma/vim-multiple-cursors'	
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'vim-syntastic/syntastic'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

"fzf
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

"Deoplete
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1

"Docker
Plug 'deoplete-plugins/deoplete-docker'
Plug 'ekalinin/dockerfile.vim'

"Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

"Javascript
Plug 'pangloss/vim-javascript'

"Go
Plug 'deoplete-plugins/deoplete-go'
Plug 'fatih/vim-go'

"Python
Plug 'deoplete-plugins/deoplete-jedi'
Plug 'nvie/vim-flake8'

"Terraform
Plug 'hashivim/vim-terraform'

call plug#end()

"Theme
set background=dark
set termguicolors
colorscheme dracula
let g:airline_theme = 'dracula'
