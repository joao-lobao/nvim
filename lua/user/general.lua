vim.api.nvim_set_keymap("n", "<Space>", "<NOP>", { noremap = true, silent = true })
vim.g.mapleader = " "

vim.o.termguicolors = true
vim.o.encoding = "utf-8"
vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.shortmess = vim.o.shortmess:gsub("S", "")
vim.o.belloff = "all"
vim.o.ignorecase = true -- search case insensitive
vim.o.smartcase = true -- search case sensitive if capital letters present
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
vim.o.undofile = true
vim.o.cul = true -- highlights the line where currently is the cursor
vim.o.ai = true -- Auto indent
vim.o.si = true -- Smart indent

-- common options
local opts = { noremap = true, silent = true }

-- MAPPINGS
-- escape insert mode
vim.api.nvim_set_keymap("i", "jj", "<Esc>", opts)
vim.api.nvim_set_keymap("i", "Ç", "ç", opts)
-- Save file
vim.api.nvim_set_keymap("n", "<leader>w", ":w<CR>", opts)

-- Refresh file
vim.api.nvim_set_keymap("n", "<leader>5", ":e!<CR>", opts)

-- Go to previous file
vim.api.nvim_set_keymap("n", "<leader>P", ":e#<CR>", opts)

-- Switching windows
vim.api.nvim_set_keymap("n", "<leader>j", "<C-w>j", opts)
vim.api.nvim_set_keymap("n", "<leader>k", "<C-w>k", opts)
vim.api.nvim_set_keymap("n", "<leader>l", "<C-w>l", opts)
vim.api.nvim_set_keymap("n", "<leader>h", "<C-w>h", opts)

-- indent
vim.api.nvim_set_keymap("n", "<leader>=", "gg=G", opts)

-- no highlight
vim.api.nvim_set_keymap("n", "-", ":nohl<CR>", opts)

------BUFFERS------
-- buffer naviagation, open and deleting
vim.api.nvim_set_keymap("n", "<leader>bn", ":bn<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>bp", ":bp<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>H", ":sp<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>V", ":vsp<CR>", opts)
-- Quitting buffer
vim.api.nvim_set_keymap("n", "gq", ":bd<CR>", opts)
vim.api.nvim_set_keymap("n", "gQ", ":bd!<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>bd", ":bp|bd #<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>bD", ":bp|bd! #<CR>", opts)
-- Quitting vim
vim.api.nvim_set_keymap("n", "<leader>q", ":q<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>Q", ":q!<CR>", opts)

-- no operation keys
vim.api.nvim_set_keymap("n", "<Up>", "<NOP>", opts)
vim.api.nvim_set_keymap("n", "<Down>", "<NOP>", opts)
vim.api.nvim_set_keymap("n", "<Left>", "<NOP>", opts)
vim.api.nvim_set_keymap("n", "<Right>", "<NOP>", opts)
vim.api.nvim_set_keymap("i", "<Up>", "<NOP>", opts)
vim.api.nvim_set_keymap("i", "<Down>", "<NOP>", opts)
vim.api.nvim_set_keymap("i", "<Left>", "<NOP>", opts)
vim.api.nvim_set_keymap("i", "<Right>", "<NOP>", opts)

-- mouse
vim.opt.mouse = "a"

-- terminal mode
vim.api.nvim_set_keymap("t", "<esc>", "<c-\\><c-n><c-w><CR>", opts)
vim.api.nvim_create_user_command("NoNumbers", ":setlocal nonumber norelativenumber", {})
vim.api.nvim_set_keymap("n", "<leader>t", ":term<CR>:NoNumbers<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>%", ":vs | term<CR>:NoNumbers<CR>", opts)
vim.api.nvim_set_keymap("n", '<leader>"', ":sp | term<CR>:NoNumbers<CR>", opts)

-- other customizations
vim.api.nvim_set_keymap("n", "<leader>s", ":source %<CR>", opts)
-- create and goto file
vim.api.nvim_set_keymap("n", "gcf", ":e <cfile><CR>", opts)

-- makes quickfix list close after list item selection (override the <CR>
-- mapping that is used in the quickfix window)
vim.cmd([[:autocmd FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>]])
vim.cmd([[:autocmd FileType qf nnoremap <buffer> <Esc> :cclose<CR>]])

-- keymap to sync through SFTP server
vim.api.nvim_set_keymap("n", "<leader>u", ":!$(pwd)/sync.sh<CR>", opts)

--------------HELPER-------------
--- for vim yank highlight
vim.cmd([[
  augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 200})
  augroup END
]])

-------------HELPER-------------
-- Remember cursor position
vim.cmd([[ 
  augroup vimrc-remember-cursor-position
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal!    g`\"" | endif
  augroup END
]])
