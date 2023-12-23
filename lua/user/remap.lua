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
vim.api.nvim_set_keymap("n", "qa", ":qa<CR>", opts)

-- no operation keys
vim.api.nvim_set_keymap("n", "<Up>", "<NOP>", opts)
vim.api.nvim_set_keymap("n", "<Down>", "<NOP>", opts)
vim.api.nvim_set_keymap("n", "<Left>", "<NOP>", opts)
vim.api.nvim_set_keymap("n", "<Right>", "<NOP>", opts)
vim.api.nvim_set_keymap("i", "<Up>", "<NOP>", opts)
vim.api.nvim_set_keymap("i", "<Down>", "<NOP>", opts)
vim.api.nvim_set_keymap("i", "<Left>", "<NOP>", opts)
vim.api.nvim_set_keymap("i", "<Right>", "<NOP>", opts)

-- Visual Maps
-- Replace all instances of highlighted words
vim.api.nvim_set_keymap("v", "<leader>r", '"hy:%s/<C-r>h//g<left><left>', opts)
-- Sort highlighted text in visual mode with Control+S
vim.api.nvim_set_keymap("v", "<C-s>", ":sort<CR>", opts)
-- Move current line down
vim.api.nvim_set_keymap("v", "J", ":m '>+1<CR>gv=gv", opts)
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
-- Automatically close brackets, parethesis, and quotes
vim.api.nvim_set_keymap("i", "'", "''<left>", opts)
vim.api.nvim_set_keymap("i", "`", "``<left>", opts)
vim.api.nvim_set_keymap("i", '"', '""<left>', opts)
vim.api.nvim_set_keymap("i", "(", "()<left>", opts)
vim.api.nvim_set_keymap("i", "[", "[]<left>", opts)
vim.api.nvim_set_keymap("i", "{", "{}<left>", opts)
vim.api.nvim_set_keymap("i", "<", "<><left>", opts)
-- calculate math expression
vim.api.nvim_set_keymap("n", "==", '0yt=A<C-r>=<C-r>"<CR><Esc>', opts)
