-- common options
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<Space>", "<NOP>", opts)

-- MAPPINGS
-- escape insert mode
vim.api.nvim_set_keymap("i", "jj", "<Esc>", opts)
vim.api.nvim_set_keymap("i", "Ç", "ç", opts)
-- Save file
vim.api.nvim_set_keymap("n", "<leader>w", ":w<CR>", opts)

-- Refresh file
vim.api.nvim_set_keymap("n", "<leader>5", ":e!<CR>", opts)

-- Go to previous file
vim.api.nvim_set_keymap("n", "<leader>P", ":b#<CR>", opts)

-- Switching windows
vim.api.nvim_set_keymap("n", "<leader>j", "<C-w>j", opts)
vim.api.nvim_set_keymap("n", "<leader>k", "<C-w>k", opts)
vim.api.nvim_set_keymap("n", "<leader>l", "<C-w>l", opts)
vim.api.nvim_set_keymap("n", "<leader>h", "<C-w>h", opts)
-- window zoom out
vim.api.nvim_set_keymap("n", "<leader>=", "<C-w>=", opts)
-- window zoom in vertically
vim.api.nvim_set_keymap("n", "<leader>|", "<C-w>|", opts)
-- window zoom in horizontally
vim.api.nvim_set_keymap("n", "<leader>_", "<C-w>_", opts)

-- adjust split sizes easier
vim.api.nvim_set_keymap("n", "<C-Left>", ":vertical resize +3<CR>", opts) -- Control+Left resizes vertical split +
vim.api.nvim_set_keymap("n", "<C-Right>", ":vertical resize -3<CR>", opts) -- Control+Right resizes vertical split -

-- no highlight
vim.api.nvim_set_keymap("n", "-", ":nohl<CR>", { noremap = true })

------BUFFERS------
-- buffer navigation, open and deleting
vim.api.nvim_set_keymap("n", "<leader>bn", ":bn<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>bp", ":bp<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>H", ":sp<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>V", ":vsp<CR>", opts)
-- Quitting buffer
vim.api.nvim_set_keymap("n", "gq", ":bd<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>bd", ":bd<CR>", opts)
vim.api.nvim_set_keymap("n", "gQ", ":bd!<CR>", opts)
-- Quitting vim
vim.api.nvim_set_keymap("n", "<leader>q", ":q<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>Q", ":q!<CR>", opts)

-- Visual Maps
-- Replace all instances of highlighted words
vim.api.nvim_set_keymap("v", "<leader>r", '"hy:%s/<C-r>h//g<left><left>', opts)
-- Sort highlighted text in visual mode with Control+S
vim.api.nvim_set_keymap("v", "<leader>s", ":sort<CR>", opts)
-- Move current line down
vim.api.nvim_set_keymap("v", "J", ":m '>+1<CR>gv=gv", opts)
vim.api.nvim_set_keymap("v", "K", ":m '>-2<CR>gv=gv", opts)
vim.api.nvim_set_keymap("v", "K", ":m '>-2<CR>gv=gv", opts)

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
-- highlight all line on markdown files
vim.api.nvim_set_keymap("n", "<leader>*", "I==<Esc>A==<Esc>", opts)
-- highlight visual selected text on markdown files
vim.api.nvim_set_keymap("v", "<leader>*", 'c==<C-r>"<Esc>a==<Esc>', opts)
-- command and keymap to run REST API calls
vim.api.nvim_create_user_command("Rest", "vnew | read !sh #", {})
vim.api.nvim_set_keymap("n", "<leader>x", ":Rest<CR>", opts)
-- help txt file to mappings and commands
vim.api.nvim_set_keymap("n", "gH", ":e ~/.config/nvim/lua/user/utils/map_cmd.txt<CR>", opts)
