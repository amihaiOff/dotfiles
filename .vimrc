ret number
syntax on

" highlight current line
set cursorline

" highlight search pattern
set hlsearch

" show matching pairs of brackets
set showmatch

" hybrid line numbers - relative number from current line and absolute number on current line"
set nu rnu

"make tab be 4 spaces
set tabstop=4

" make shift (>>) be 4 spaces
set shiftwidth=4

set autoindent

" wrap lines 
set wrap 

" visual autocomplete for command menu "
set wildmenu

" move vertically by visual line (don't skip wrapped lines)
nmap j gj
nmap k gk

"enable color theme"
if !has('gui running')
    set t_Co=256
endif

"vim color scheme"
" colorscheme desert

function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" set status line to be persistant and format it "
set laststatus=2
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c

" doesn't work yet needs to overide iterm shortcuts " 
" Move a line of text using ALT+[jk] or Command+[jk] on mac"
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

" auto-install if no plugings found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
        endif

call plug#begin('~/.vim/plugged')
Plug 'sainnhe/everforest'
Plug 'vim-airline/vim-airline'
" Plug 'sheerun/vim-polyglot'
call plug#end()

let g:everforest_disable_italic_comment = 1
colorscheme everforest
