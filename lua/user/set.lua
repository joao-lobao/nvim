vim.g.mapleader = " "
vim.o.termguicolors = true
vim.o.encoding = "utf-8"
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
vim.o.wildignorecase = true
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
vim.o.laststatus = 3 -- show only one status line even if there are multiple splits
-- no mouse
vim.o.mouse = ""
vim.o.wildignore = "*/node_modules/**, */dist/**, .git/**" -- list of file patterns to ignore by default on commands like vimgrep and find
vim.opt.exrc = true -- allow local .nvim.lua .vimrc .exrc files
vim.opt.secure = true -- disable shell and write commands in local .nvim.lua .vimrc .exrc files
-- vim.opt.spell = true -- important maps: zw zg zuw zug z=
-- vim.opt.spelllang = { "en_us", "pt_pt" }
