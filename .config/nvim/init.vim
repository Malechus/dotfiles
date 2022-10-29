" Line numbering
:set number
":set relativenumber


"" Colorscheme
set termguicolors
colorscheme custom

" Disable vi compatability
set nocompatible

" Enable filetype detection
filetype on
filetype plugin on
filetype indent on

" Enable syntax highlighting
syntax on

" Bar setup
set showcmd
set ignorecase

"PLUGINS
call plug#begin('~/.config/nvim/plugged')

	Plug 'christoomey/vim-system-copy'
	Plug 'OmniSharp/omnisharp-vim'	
	Plug 'w0rp/ale'
	Plug 'preservim/nerdtree'
	Plug 'valloric/MAtchTagAlways'
	Plug 'jiangmiao/auto-pairs'
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'

call plug#end()

"MAPPING
map <C-o> :NERDTreeToggle<CR>
map <C-i> :PlugInstall<CR>
map <C-f> :Files<CR>
