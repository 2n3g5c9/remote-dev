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
    Plug 'ekalinin/dockerfile.vim'

    " Git
    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'

    " Packer
    Plug 'hashivim/vim-packer'

    " Terraform
    Plug 'hashivim/vim-terraform'
    Plug 'juliosueiras/vim-terraform-completion'
    let g:terraform_align=1
    let g:terraform_completion_keys = 1
    let g:terraform_fmt_on_save=1
    let g:syntastic_terraform_tffilter_plan = 1
"}}}

" Development {{{
    " Coc
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    let g:coc_global_extensions = ['coc-html', 'coc-json', 'coc-lists', 'coc-sh']

    " if hidden is not set, TextEdit might fail.
    set hidden

    " Some servers have issues with backup files, see #649
    set nobackup
    set nowritebackup

    " Better display for messages
    set cmdheight=2

    " Smaller updatetime for CursorHold & CursorHoldI
    set updatetime=300

    " don't give |ins-completion-menu| messages.
    set shortmess+=c

    " always show signcolumns
    set signcolumn=yes

    " Use tab for trigger completion with characters ahead and navigate.
    " Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
    inoremap <silent><expr> <TAB>
          \ pumvisible() ? "\<C-n>" :
          \ <SID>check_back_space() ? "\<TAB>" :
          \ coc#refresh()
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    " Use <c-space> to trigger completion.
    inoremap <silent><expr> <c-space> coc#refresh()

    " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
    " Coc only does snippet and additional edit on confirm.
    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

    " Use `[c` and `]c` to navigate diagnostics
    nmap <silent> [c <Plug>(coc-diagnostic-prev)
    nmap <silent> ]c <Plug>(coc-diagnostic-next)

    " Remap keys for gotos
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)

    " Use K to show documentation in preview window
    nnoremap <silent> K :call <SID>show_documentation()<CR>

    function! s:show_documentation()
      if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
      else
        call CocAction('doHover')
      endif
    endfunction

    " Highlight symbol under cursor on CursorHold
    autocmd CursorHold * silent call CocActionAsync('highlight')

    " Remap for rename current word
    nmap <leader>rn <Plug>(coc-rename)

    " Remap for format selected region
    vmap <leader>f  <Plug>(coc-format-selected)
    nmap <leader>f  <Plug>(coc-format-selected)

    augroup mygroup
      autocmd!
      " Setup formatexpr specified filetype(s).
      autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
      " Update signature help on jump placeholder
      autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    augroup end

    " Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
    vmap <leader>a  <Plug>(coc-codeaction-selected)
    nmap <leader>a  <Plug>(coc-codeaction-selected)

    " Remap for do codeAction of current line
    nmap <leader>ac  <Plug>(coc-codeaction)
    " Fix autofix problem of current line
    nmap <leader>qf  <Plug>(coc-fix-current)

    " Use `:Format` to format current buffer
    command! -nargs=0 Format :call CocAction('format')

    " Use `:Fold` to fold current buffer
    command! -nargs=? Fold :call     CocAction('fold', <f-args>)

    " Add diagnostic info for https://github.com/itchyny/lightline.vim
    let g:lightline = {
          \ 'colorscheme': 'wombat',
          \ 'active': {
          \   'left': [ [ 'mode', 'paste' ],
          \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
          \ },
          \ 'component_function': {
          \   'cocstatus': 'coc#status'
          \ },
          \ }

    " Using CocList
    " Show all diagnostics
    nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
    " Manage extensions
    nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
    " Show commands
    nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
    " Find symbol of current document
    nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
    " Search workspace symbols
    nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
    " Do default action for next item.
    nnoremap <silent> <space>j  :<C-u>CocNext<CR>
    " Do default action for previous item.
    nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
    " Resume latest coc list
    nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

    " Go
    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
    let g:go_def_mode='gopls'
    let g:go_info_mode='gopls'

    " Javascript
    Plug 'pangloss/vim-javascript'     " JavaScript support
    Plug 'leafgarland/typescript-vim'  " TypeScript syntax
    Plug 'peitalin/vim-jsx-typescript' " JSX syntax
    Plug 'jparise/vim-graphql'         " GraphQL syntax
    Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
    autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
    autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear
    let g:coc_global_extensions += ['coc-tsserver']
    if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
      let g:coc_global_extensions += ['coc-eslint']
    endif

    "Prettier
    Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
    if isdirectory('./node_modules') && isdirectory('./node_modules/prettier')
      let g:coc_global_extensions += ['coc-prettier']
    endif

    " Python
    Plug 'davidhalter/jedi-vim'
    Plug 'nvie/vim-flake8'
    let g:coc_global_extensions += ['coc-jedi']
"}}}

call plug#end()
