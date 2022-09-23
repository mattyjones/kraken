filetype plugin indent on
syntax enable

set termguicolors

set number

"Set the background theme to dark
set background = "dark"

"Call the theme
colorscheme nord
" colorscheme onedark

" Set the airline theme
let g:airline_theme="nord"
" let g:airline_theme="onedark"
let g:airline#extensions#tabline#enabled=1
let g:airline_powerline_fonts=1

"This line enables the true color support.
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

"Note, the above line is ignored in Neovim 0.1.5 above, use this line instead.

set expandtab
set autoindent
set softtabstop=4
set shiftwidth=2
set tabstop=4

"Enable mouse click for nvim
set mouse=a
"Fix cursor replacement after closing nvim
set guicursor=
"Shift + Tab does inverse tab
inoremap <S-Tab> <C-d>

"See invisible characters
"set list listchars=tab:>\ ,trail:+,eol:$
