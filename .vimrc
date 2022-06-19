set number
:syntax on

"highlight current line"
"set cursorline"

"highlight search pattern"
set hlsearch

"show matching pairs of brackets"
set showmatch

"enable color theme"
if !has('gui running')
	set t_Co=256
endif

"enable color support"
set termguicolors
"vim color scheme"

colorscheme desert

function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" set status line to be persistant and format it "
set laststatus=2
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c

# doesn't work yet needs to overide iterm shortcuts 
" Move a line of text using ALT+[jk] or Command+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z
