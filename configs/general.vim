filetype plugin indent on
colorscheme gruvbox
set background=dark

let mapleader = "\<Space>"

let g:netrw_preview   = 1
" let g:netrw_liststyle = 3
let g:netrw_winsize   = 30

syntax on
set termguicolors
set encoding=utf-8
set incsearch
set hlsearch
set shortmess-=S
set belloff=all
set ignorecase " search case insensitive
set smartcase " search case sensitive if capital letters present
set ruler
set number
set relativenumber
set nowrap
set path+=**
set wildmenu
" on neovim 0.5 onwards need to install xclip (sudo apt-get install xclip)
set clipboard+=unnamedplus
set foldmethod=indent
set foldlevelstart=99
" The width of a TAB is set to 2.
set tabstop=2
" Still it is a \t. It is just that
" Vim will interpret it to be having
" a width of 2.
set shiftwidth=2    " Indents will have a width of 2
set softtabstop=2   " Sets the number of columns for a TAB
set expandtab       " Expand TABs to spaces
set noswapfile
set nobackup
set undodir=~/.config/undodir
set undofile
set cul " highlights the line where currently is the cursor
set ai "Auto indent
set si "Smart indent

" MAPPINGS
" escape insert mode
inoremap jj <Esc>
inoremap Ç ç
" Save file
nnoremap <leader>w :w<CR>

" Refresh file
nnoremap <leader>r :e!<CR>

" Go to previous file
nnoremap <leader>P :e#<CR>

" Switching windows
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l
nnoremap <leader>h <C-w>h

" indent
nnoremap == gg=G''

" no highlight
nnoremap <leader>nh :nohl<CR>
nnoremap - :nohl<CR>


" ------BUFFERS------
" buffer naviagation, open and deleting
nnoremap <leader>bn :bn<CR>
nnoremap <leader>bp :bp<CR>
" Quitting buffer
nnoremap gq :bp\|bd #<CR>
nnoremap gQ :bp\|bd! #<CR>
nnoremap <leader>bd :bd<CR>
nnoremap <leader>bD :bd!<CR>
" Quitting vim
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :q!<CR>

" shift lines up and down in visual mode
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" no operation keys
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>

" open Netrw explorer
nnoremap <leader>e :Explore<CR>

" terminal mode mappings
tnoremap <leader>h <c-\><c-n><c-w>h
tnoremap <leader>j <c-\><c-n><c-w>j
tnoremap <leader>k <c-\><c-n><c-w>k
tnoremap <leader>l <c-\><c-n><c-w>l
tnoremap <leader>bn <c-\><c-n><c-w>:bn<CR>
tnoremap <leader>bp <c-\><c-n><c-w>:bp<CR>

" other customizations
nnoremap <leader>vrc :e ~/.config/nvim/init.vim<CR>
nnoremap <leader>s :source %<CR>
" create and goto file
nnoremap gcf :e <cfile><CR>
" perform arithmetic operations
nnoremap Q 0f=a<space><space><Esc>d$0yt=A<C-r>=<C-r>"<CR><Esc>

"-------------HELPER-------------
" autocorrect common mistakes
let s:auto_correct_loaded=0

function! AutoCorrect()
    if exists('s:autocorrect_loaded')
        return
    else
        let s:autocorrect_loaded='1'
    endif
ia funciton function
ia cosnt const
ia conts const
ia thsi this
ia htis this
ia tset test
ia reutrn return
ia retunr return
ia retun return
ia retur return
endfunction
call AutoCorrect()



"-------------HELPER-------------
" to highlight char as red in 79 column
" highlight OverLength ctermbg=red guibg=red
" call matchadd('OverLength', '\%<80v.\%>79v')



"-------------HELPER-------------
" open a buffer the last registers (copied strings)
function! s:open_registers() abort
  10new
  call append(0, [getreg(0), getreg(1), getreg(2), getreg(3), getreg(4), getreg(5), getreg(6)])
  goto 1
endfunc
nnoremap <leader>or :call <SID>open_registers()<CR>



"-------------HELPER-------------
" Remember cursor position
augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal!    g`\"" | endif
augroup END



"-------------HELPER-------------
" for vim yank highlight
augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 200})
augroup END



"-------------HELPER-------------
" create an unexistent class
function! s:create_and_go_to_class() abort
  norm yiw
  enew
  let reg = getreg(0)
  call append(0, 'export class '..reg..' {}')
  goto 1
  norm 2w
  norm gUl
  norm w
endfunc
nnoremap <leader>cc :call <SID>create_and_go_to_class()<CR>
