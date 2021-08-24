inoremap jj <Esc>
let mapleader = " "

" Window management {{{
    " Split windows
    nnoremap <leader>- <C-w>s
    nnoremap <leader>_ <C-w>v
    nnoremap <leader>q <C-w>o
    nnoremap <leader>s <C-w>r
    nnoremap <leader>= <C-w>=
    nnoremap <leader>+ <C-w>s

    " Move windows around
    nnoremap <leader>h :wincmd h<CR>
    nnoremap <leader>j :wincmd j<CR>
    nnoremap <leader>k :wincmd k<CR>
    nnoremap <leader>l :wincmd l<CR>

    " Resize windows
    nnoremap <leader>L :vertical resize +5<CR>
    nnoremap <leader>H :vertical resize -5<CR>
    nnoremap <leader>J :resize +5<CR>
    nnoremap <leader>K :resize -5<CR>

    " Buffers
    nmap <C-o> :Buffers<CR>
"}}}

" Text manipulation {{{
    " Smooth scrolling
    nmap <C-j> <Plug>(SmoothieDownwards)
    nmap <C-k> <Plug>(SmoothieUpwards)

    " Cut, Copy & Paste to system clipboard
    noremap <leader>d "+d
    noremap <leader>y "+y
    noremap <leader>p "+p
    noremap <leader>P "+P

    " Move lines around
    nnoremap <S-Up> :m-2<CR>
    nnoremap <S-Down> :m+<CR>
    inoremap <S-Up> <Esc>:m-2<CR>
    inoremap <S-Down> <Esc>:m+<CR>
"}}}

" Miscellaneous {{{
    " Colorised pairs
    let g:rainbow_active = 1

    " NERDCommenter
    map <leader>/ <Plug>NERDCommenterToggle

    " Tagbar
    nnoremap tb :TagbarToggle<CR>

    " WhichKey
    nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
    set timeoutlen=500

    " fzf and rg
    nnoremap ; :Files<CR>
    nnoremap ' :GFiles<CR>
    nnoremap \ :Rg<CR>

    " git
    nnoremap <leader>ga :G add %:p<CR><CR>
    nnoremap <leader>gs :Gstatus<CR>
    nnoremap <leader>gc :Gcommit -v -q<CR>
    nnoremap <leader>gd :Gdiff<CR>
    nnoremap <leader>gf :diffget //2<CR>
    nnoremap <leader>gh :diffget //3<CR>

    " Terraform
    nnoremap <leader>ti :Terraform init<CR>
    nnoremap <leader>tp :Terraform plan -out terraform.tfplan<CR>
    nnoremap <leader>ta :Terraform apply terraform.tfplan<CR>
    nnoremap <leader>td :Terraform destroy terraform.tfplan<CR>
    nnoremap <leader>tf :TerraformFmt<CR>

    " JSON formatting
    command! JSON %!jq .
    nnoremap <leader>jq :JSON<CR>
"}}}
