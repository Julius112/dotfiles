execute pathogen#infect()
filetype plugin indent on
syntax on
set laststatus=2

set foldmethod=syntax
colorscheme wombat256grf

if &diff
	highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
	highlight DiffDelete cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
	highlight DiffChange cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
	highlight DiffText   cterm=bold ctermfg=10 ctermbg=88 gui=none guifg=bg guibg=Red
endif

" Save and build
command! W w|!make

" Use system keyboard
set clipboard=unnamed

" Set search highlighting
:set hlsearch
" Press Space to turn off highlighting and clear any message already displayed.
:nnoremap <silent> # :nohlsearch<Bar>:echo<CR>
