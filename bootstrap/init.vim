"General
syntax on

set noerrorbells
set number
set relativenumber
set nocompatible
set tabstop=4 softtabstop=4
set shiftwidth=4
set smartindent
set smartcase
set incsearch
set wrap
set ruler
set mouse=a

set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=lightgrey

"Remappings
inoremap jj <Esc>
let mapleader = " "
"Move around windows
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
"Resize windows
nnoremap <leader>= :vertical resize +5<CR>
nnoremap <leader>- :vertical resize -5<CR>
nnoremap <leader>+ :horizontal resize +5<CR>
nnoremap <leader>_ :horizontal resize -5<CR>
"Move lines around
nnoremap <S-Up> :m-2<CR>
nnoremap <S-Down> :m+<CR>
inoremap <S-Up> <Esc>:m-2<CR>
inoremap <S-Down> <Esc>:m+<CR>
"Pairs
let g:rainbow_active = 1
"NERDTree
nnoremap nn :NERDTreeToggle<CR>
"fzf and rg
nnoremap ; :Files<CR>
nnoremap \ :Rg<CR>
"git
nnoremap <leader>ga :G add %:p<CR><CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gc :Gcommit -v -q<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gf :diffget //2<CR>
nnoremap <leader>gh :diffget //3<CR>

"Plugins
call plug#begin('~/.local/share/nvim/plugged')

"General
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'jiangmiao/auto-pairs'
Plug 'jremmen/vim-ripgrep'
Plug 'luochen1990/rainbow'
Plug 'majutsushi/tagbar'
Plug 'neomake/neomake'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'terryma/vim-multiple-cursors'	
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-syntastic/syntastic'
Plug 'wellle/targets.vim'

"fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
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

"TabNine
Plug 'tbodt/deoplete-tabnine', { 'do': './install.sh' }

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
Plug 'stamblerre/gocode', { 'rtp': 'vim', 'do': '~/.vim/plugged/gocode/vim/symlink.sh' }

"Python
Plug 'davidhalter/jedi-vim'
Plug 'deoplete-plugins/deoplete-jedi'
Plug 'nvie/vim-flake8'

"Terraform
Plug 'hashivim/vim-terraform'
Plug 'juliosueiras/vim-terraform-completion'
let g:terraform_fmt_on_save=1

call plug#end()

"Theme
set termguicolors
let g:airline_theme = 'dracula'
let g:dracula_colorterm = 0
colorscheme dracula
