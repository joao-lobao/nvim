vim.cmd [[ silent! colorscheme gruvbox]]

vim.api.nvim_set_keymap('n', '<Space>', '<NOP>', { noremap = true, silent = true })
vim.g.mapleader = ' '

vim.o.termguicolors = true
vim.o.encoding = "utf-8"
vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.shortmess = vim.o.shortmess:gsub('S', '')
vim.o.belloff = "all"
vim.o.ignorecase = true -- search case insensitive
vim.osmartcase = true -- search case sensitive if capital letters present
vim.o.ruler = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.path = "**"
vim.o.wildmenu = true
-- on neovim 0.5 onwards need to install xclip (sudo apt-get install xclip)
vim.o.clipboard = "unnamedplus"
vim.o.foldmethod = "indent"
vim.o.foldlevelstart = 99
-- The width of a TAB is set to 2.
vim.o.tabstop = 2
-- Still it is a \t. It is just that
-- Vim will interpret it to be having
-- a width of 2.
vim.o.shiftwidth = 2 -- Indents will have a width of 2
vim.o.softtabstop = 2 -- Sets the number of columns for a TAB
vim.o.expandtab = true -- Expand TABs to spaces
vim.o.swapfile = false
vim.o.backup = false
vim.o.undodir = "~/.config/undodir"
vim.o.undofile = true
vim.o.cul = true -- highlights the line where currently is the cursor
vim.o.ai = true -- Auto indent
vim.o.si  = true -- Smart indent

-- MAPPINGS
-- escape insert mode
vim.api.nvim_set_keymap('i', 'jj', '<Esc>', { noremap = true })
vim.api.nvim_set_keymap('i', 'Ç', 'ç', { noremap = true })
-- Save file
vim.api.nvim_set_keymap('n', '<leader>w', ':w<CR>', { noremap = true })

-- Refresh file
vim.api.nvim_set_keymap('n', '<leader>5', ':e!<CR>', { noremap = true })

-- Go to previous file
vim.api.nvim_set_keymap('n', '<leader>P', ':e#<CR>', { noremap = true })

-- Switching windows
vim.api.nvim_set_keymap('n', '<leader>j', '<C-w>j', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>k', '<C-w>k', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>l', '<C-w>l', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>h', '<C-w>h', { noremap = true })

-- indent
vim.api.nvim_set_keymap('n', '<leader>=', 'gg=G', { noremap = true })

-- no highlight
vim.api.nvim_set_keymap('n', '-', ':nohl<CR>', { noremap = true })


------BUFFERS------
-- buffer naviagation, open and deleting
vim.api.nvim_set_keymap('n', '<leader>bn', ':bn<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>bp', ':bp<CR>', { noremap = true })
-- Quitting buffer
vim.api.nvim_set_keymap('n', 'gq', ':bp|bd #<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', 'gQ', ':bp|bd! #<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>bd', ':bd<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>bD', ':bd!<CR>', { noremap = true })
-- Quitting vim
vim.api.nvim_set_keymap('n', '<leader>q', ':q<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>Q', ':q!<CR>', { noremap = true })

-- no operation keys
vim.api.nvim_set_keymap('n', '<Up>', '<NOP>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Down>', '<NOP>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Left>', '<NOP>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Right>', '<NOP>', { noremap = true })
vim.api.nvim_set_keymap('i', '<Up>', '<NOP>', { noremap = true })
vim.api.nvim_set_keymap('i', '<Down>', '<NOP>', { noremap = true })
vim.api.nvim_set_keymap('i', '<Left>', '<NOP>', { noremap = true })
vim.api.nvim_set_keymap('i', '<Right>', '<NOP>', { noremap = true })

-- terminal mode mappings
vim.api.nvim_set_keymap('t', '<leader>h', '<c-\\><c-n><c-w>h', { noremap = true })
vim.api.nvim_set_keymap('t', '<leader>j', '<c-\\><c-n><c-w>j', { noremap = true })
vim.api.nvim_set_keymap('t', '<leader>k', '<c-\\><c-n><c-w>k', { noremap = true })
vim.api.nvim_set_keymap('t', '<leader>l', '<c-\\><c-n><c-w>l', { noremap = true })
vim.api.nvim_set_keymap('t', '<leader>l', '<c-\\><c-n><c-w>l', { noremap = true })
vim.api.nvim_set_keymap('t', '<leader>bn', '<c-\\><c-n><c-w>:bn<CR>', { noremap = true })
vim.api.nvim_set_keymap('t', '<leader>bp', '<c-\\><c-n><c-w>:bp<CR>', { noremap = true })

-- other customizations
vim.api.nvim_set_keymap('n', '<leader>s', ':source %<CR>', { noremap = true })
-- create and goto file
vim.api.nvim_set_keymap('n', 'gcf', ':e <cfile><CR>', { noremap = true })



-------------HELPER-------------
-- Remember cursor position
vim.cmd [[ 
  augroup vimrc-remember-cursor-position
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal!    g`\"" | endif
  augroup END
]]
