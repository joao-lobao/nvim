vim.g.mapleader = " "
vim.o.termguicolors = true
vim.o.encoding = "utf-8"
vim.o.hlsearch = false
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
-- no mouse
vim.opt.mouse = ""
