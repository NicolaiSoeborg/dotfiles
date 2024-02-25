" language en_US.utf8

" Auto install plug manager:
"if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
"  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
"endif
" Install: curl -fLo ${XDG_DATA_HOME:-~/.local/share}/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

" Plugins:
call plug#begin('~/.local/share/nvim/plugged')
Plug 'terryma/vim-multiple-cursors'  " ctrl+d (skip w/ ctrl+k)
Plug 'junegunn/vim-easy-align'       " visual mark, use EasyAlign command + space
" Plug 'jamessan/vim-gnupg'            " open encrypted files
Plug 'neoclide/coc.nvim', {'branch': 'release'}           " Language Server
Plug 'editorconfig/editorconfig-vim'                      " EditorConfig support
" Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' } " File explorer (requires: pip3 install --user pynvim)
" Plug 'neomake/neomake'
Plug 'preservim/nerdtree'            ", { 'on': 'NERDTreeToggle' }
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
set shiftwidth=4

" Focus cursor middle:
"set relativenumber
set scrolloff=15

" Enable truecolor
set termguicolors

" YAML stuff:
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

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

" Beautify json command:
com! BeautifyJSON %!python3 -m json.tool

" Fancy tab completion
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
