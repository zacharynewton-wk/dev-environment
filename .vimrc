syntax on
colorscheme onedark
set tabstop=2
set shiftwidth=2
set expandtab
set number
set autoindent
set smartindent
set pastetoggle=<f5>

set laststatus=2
let g:airline_theme='onedark'

let g:netrw_liststyle=3

set winminwidth=5
nnoremap <silent> <Leader>> :exe "resize" . (winwidth(0) * 3/2)<CR>
nnoremap <silent> <Leader>< :exe "resize" . (winwidth(0) * 2/3)<CR>
nnoremap <C-,> <C-w><
nnoremap <C-.> <C-w>>
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

map <F9> <Esc>:vsp .<CR>:vertical resize 30<CR>
map <F10> <Esc>:tabnew<CR><F9><C-w><Right>:e .<CR>
