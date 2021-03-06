" disable compatibility mode
set nocompatible

" Pathogen!
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()

" turn plugin/indent back on
filetype plugin indent on

" enable more colors
set t_Co=256

" Syntax highlighting
syntax on
set background=dark
colorscheme solarized
" set the encoding!
set encoding=utf-8
" backspace over everything
set backspace=indent,eol,start
" show line numbers
set number
" status line
hi User9 ctermfg=LightGray ctermbg=DarkGray
set statusline=%9*\ %y\ (\ %l\ /\ %L\ ):%v\ (%P)\ %F\ %m%=%{fugitive#statusline()}\    
" always show the status line
set laststatus=2
" Show some context while scrolling
set scrolloff=5

" Show trailing whitespace:
autocmd InsertLeave,ColorScheme,FileType *
	\ highlight TrailingWhitespace ctermbg=darkred guibg=darkred |
	\ match TrailingWhitespace /\s\+$/

autocmd InsertEnter * match
autocmd BufNewFile,BufReadPost *.cljx setfiletype clojure
autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4

autocmd BufNewFile,BufReadPost *.cljx setfiletype clojure

" tabs
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab
set noexpandtab

" search & highlight
set incsearch
set hlsearch
set smartcase
set ignorecase

" change backup directory
if isdirectory($HOME . '/.vim/backup') == 0
	:silent !mkdir -p ~/.vim/backup >/dev/null 2>&1
endif
set backupdir=~/.vim/backup//
set backup

" change swap directory
if isdirectory($HOME . '/.vim/swap') == 0
	:silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
endif
set directory=~/.vim/swap//

" viminfo stores the state of your previous editing session
set viminfo+=n~/.vim/viminfo

" change undo directory
if exists("+undofile")
	if isdirectory($HOME . '/.vim/undo') == 0
		:silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
	endif
	set undodir=~/.vim/undo//
	set undofile
endif

" working dir: nearest ancestor dir containing .git/.hg/.svn/.bzr/_darcs
let g:ctrlp_working_path_mode = 2
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files']

" custom functions
let mapleader = ","

" tabs
map <leader>a :tabnew<cr>
map <leader>c :tabclose<cr>
map <leader>r :tabp<cr>
map <leader>s :tabn<cr>

" Ctrl-P
map <leader>t :CtrlP<cr>

" Change linewise up/down to rowwise up/down
nmap j gj
nmap k gk

" Automatically insert matching parens/brackets/etc
inoremap ( ()<Esc>i
inoremap { {}<Esc>i
inoremap [ []<Esc>i
inoremap " ""<Esc>i

" Escape from automatically inserted end chars

inoremap ) <c-r>=ClosePair(')')<CR>
inoremap ] <c-r>=ClosePair(']')<CR>
inoremap } <c-r>=ClosePair('}')<CR>
inoremap " <c-r>=QuoteDelim('"')<CR>

function ClosePair(char)
	if getline('.')[col('.') - 1] == a:char
		return "\<Right>"
	else
		return a:char
	endif
endfunction
function QuoteDelim(char)
	let line = getline('.')
	let col = col('.')
	if line[col - 2] == "\\"
		" Inserting an escaped (and therefore conditionally asymmetric) quotation mark into the string
		return a:char
	elseif line[col-1] == a:char
		" Escaping out of the string
		return "\<Right>"
	else
		"Starting a string
		return a:char.a:char."\<Esc>i"
	endif
endfunction
