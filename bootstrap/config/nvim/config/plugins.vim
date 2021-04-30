call plug#begin('~/.local/share/nvim/plugged')

" General {{{
    " Color scheme
    Plug 'gruvbox-community/gruvbox'

    " Operations on brackets, parens, quotes in pair
    Plug 'jiangmiao/auto-pairs'

    " Fuzzy finder
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'

    " Jump on multiple characters
    Plug 'justinmk/vim-sneak'

    " Available keybindings in popup
    Plug 'liuchengxu/vim-which-key'

    " Different level of parentheses in different colors
    Plug 'luochen1990/rainbow'

    " Tags of the current file
    Plug 'majutsushi/tagbar'

    " Useful start screen
    Plug 'mhinz/vim-startify'

    " Asynchronously run programs
    Plug 'neomake/neomake'

    " Fast color highlighter
    Plug 'norcalli/nvim-colorizer.lua'

    " Nice and smooth scrolling
    Plug 'psliwka/vim-smoothie'

    " File system explorer
    Plug 'preservim/nerdtree'

    " Comment functions
    Plug 'preservim/nerdcommenter'
    let NERDSpaceDelims = 1

    " File icons all around vim
    Plug 'ryanoasis/vim-devicons'

    " Syntax highlighter for NERDtree
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

    " Handy features for surroundings
    Plug 'tpope/vim-surround'

    " Lean status/tabline
    Plug 'vim-airline/vim-airline'

    " Syntax checking hacks
    Plug 'vim-syntastic/syntastic'

    " Additional text objects
    Plug 'wellle/targets.vim'
"}}}

" Infrastructure {{{
    " Ansible
    Plug 'pearofducks/ansible-vim'

    " Docker
    Plug 'deoplete-plugins/deoplete-docker'
    Plug 'ekalinin/dockerfile.vim'

    " Git
    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'

    " Packer
    Plug 'hashivim/vim-packer'

    " Terraform
    Plug 'hashivim/vim-terraform'
    Plug 'juliosueiras/vim-terraform-completion'
    let g:terraform_fmt_on_save=1
    let g:terraform_align=1
"}}}

" Development {{{
    " Deoplete
    if has('nvim')
      Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    else
      Plug 'Shougo/deoplete.nvim'
      Plug 'roxma/nvim-yarp'
      Plug 'roxma/vim-hug-neovim-rpc'
    endif
    let g:deoplete#enable_at_startup = 1

    " Go
    Plug 'deoplete-plugins/deoplete-go'
    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
    let g:go_def_mode='gopls'
    let g:go_info_mode='gopls'

    " Javascript
    Plug 'pangloss/vim-javascript'    " JavaScript support
    Plug 'leafgarland/typescript-vim' " TypeScript syntax
    Plug 'maxmellon/vim-jsx-pretty'   " JS and JSX syntax
    Plug 'jparise/vim-graphql'        " GraphQL syntax

    "Prettier
    Plug 'prettier/vim-prettier', { 'do': 'yarn install' }

    " Python
    Plug 'davidhalter/jedi-vim'
    Plug 'deoplete-plugins/deoplete-jedi'
    Plug 'nvie/vim-flake8'

    " TabNine
    Plug 'tbodt/deoplete-tabnine', { 'do': './install.sh' }
"}}}

call plug#end()
