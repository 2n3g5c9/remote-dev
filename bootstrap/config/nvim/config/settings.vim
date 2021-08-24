" General configuration {{{
    " Enable syntax highlighting
    syntax on

    " Highlight current line
    set cursorline

    " Enable use of the mouse for all modes
    set mouse=a

    " Center cursor when scrolling
    set scrolloff=8

    " Display relative numbers
    set number
    set relativenumber

    " Set the sign column always on
    set signcolumn=yes

    " Show unseeing characters
    set list
    set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<

    " Silence the error bells
    set noerrorbells

    " Record more lines in history
    set history=5000

    " Keep editing buffer in the background
    set hidden

    " Keep history clean
    set noswapfile
    set nobackup
    set undodir=~/.vim/undodir
    set undofile
"}}}

" Set up smarter search behaviour {{{
    set nohlsearch  " Stop highlighting after a search
    set incsearch   " Lookahead as search pattern is specified
    set ignorecase  " Ignore case in all searches...
    set smartcase   " ...unless uppercase letters used
"}}}

" Text, tab and indent related configuration {{{
    " 1 tab == 4 spaces
    set shiftwidth=4
    set tabstop=4 softtabstop=4
    set expandtab

    " Indent and wrap lines
    set autoindent
    set smartindent
    set wrap

    " Set rule at 80 columns
    set colorcolumn=80
    highlight ColorColumn ctermbg=0 guibg=lightgrey
"}}}

"netrw configuration {{{
    let g:netrw_banner = 0
    let g:netrw_liststyle = 3
    let g:netrw_altv = 1
    let g:netrw_winsize = 25
"}}}

" Color configuration {{{
    let g:gruvbox_contrast_dark = 'medium'
    colorscheme gruvbox
"}}}
