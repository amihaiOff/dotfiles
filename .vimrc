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
