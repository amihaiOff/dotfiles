let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" --------------------
" set single settings
" --------------------
set number
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

" use mouse
set mouse=a

set autoindent

" wrap lines 
set wrap 

" visual autocomplete for command menu "
set wildmenu

" ---------------------------------------------------------------------------------
" ---------------------------------------------------------------------------------

" move vertically by visual line (don't skip wrapped lines)
" nmap j gj
" nmap k gk

"enable color theme"
if !has('gui running')
    set t_Co=256
endif
"""
"
" move a line of text using ALT+[jk] or Command+[jk] on mac"
"nmap <M-j> mz:m+<cr>`z
"nmap <M-k> mz:m-2<cr>`z
"vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
"vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z


" auto-install if no plugings found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
        endif

" --------
" Plug Ins
" --------
call plug#begin('~/.vim/plugged')
Plug 'sainnhe/everforest' " color theme
Plug 'vim-airline/vim-airline' " status line
"Plug 'wincent/terminus'
Plug 'dense-analysis/ale'  " linter
Plug 'tomtom/tcomment_vim'  " comment \ uncomment easily
Plug 'sheerun/vim-polyglot' " syntax highlighting
Plug 'jiangmiao/auto-pairs' "auto insert closing brackets
Plug 'preservim/tagbar' " tag manager
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdtree'

" --- search plugs ---
Plug 'mileszs/ack.vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
call plug#end()

set background=dark
let g:everforest_disable_italic_comment = 1
colorscheme everforest


" Jump between splits with jklh keys
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>


" leader shortcuts
nnoremap <leader>f :NERDTreeFind<cr>


" ==== ale configuration ====
let g:ale_lint_on_text_changed = 1
let g:ale_lint_on_save = 1

let g:ale_linters = { 
            \'python' : ['flake8', 'pylint', 'mypy']
            \}

" === coc.nvim ===
" go to definition
nmap <silent> gd <Plug>(coc-definition)
" go to definition in new upper half split
nmap <silent> gds :call CocAction('jumpDefinition', 'split')<CR>
" go to definition in new vertical split (to the right)
nmap <silent> gds :call CocAction('jumpDefinition', 'vsplit')<CR>
" go to implementation
nmap <silent> gi <Plug>(coc-definition)

" Use D to show documentation in preview window
nnoremap <silent> D :call <SID>show_documentation()<CR>

function! s:show_documentation()
    if (index(['vim', 'help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction
