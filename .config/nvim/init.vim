language en_US

" Plugins:
call plug#begin('~/.local/share/nvim/plugged')
Plug 'terryma/vim-multiple-cursors'  " ctrl+d (skip w/ ctrl+k)
Plug 'junegunn/vim-easy-align'       " visual mark, use EasyAlign command + space
Plug 'jamessan/vim-gnupg'            " open encrypted files
Plug 'neoclide/coc.nvim', {'branch': 'release'} " Language Server
Plug 'editorconfig/editorconfig-vim' " EditorConfig support
Plug 'neomake/neomake'
call plug#end()

" Change keybindings for multi cursor
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_next_key='<C-d>'
"let g:multi_cursor_prev_key='<C-S-d>'
let g:multi_cursor_skip_key='<C-k>'
let g:multi_cursor_quit_key='<Esc>'

" Auto open :Neomake error list (a bit annoying)
"let g:neomake_open_list = 2

" Make backspace behave in a sane manner
set backspace=indent,eol,start

" Set 'visual' tabsize to 4 spaces
set tabstop=4

" Focus cursor middle:
"set relativenumber
set scrolloff=15

" Tab navigation like Firefox.
nnoremap <C-S-tab> :tabprevious<CR>
nnoremap <C-tab>   :tabnext<CR>
nnoremap <C-t>     :tabnew<CR>
inoremap <C-S-tab> <Esc>:tabprevious<CR>i
inoremap <C-tab>   <Esc>:tabnext<CR>i
inoremap <C-t>     <Esc>:tabnew<CR>

" Esc removes highlight: http://stackoverflow.com/a/4372666/1588959
nnoremap <silent> <esc> :noh<cr><esc>

" Force saving files that require root permission 
cnoremap W! w !sudo tee > /dev/null %

