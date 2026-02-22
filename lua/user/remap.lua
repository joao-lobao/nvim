-- common options
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<Space>", "<NOP>", opts)

-- MAPPINGS
-- escape insert mode
vim.api.nvim_set_keymap("i", "jj", "<Esc>", opts)
vim.api.nvim_set_keymap("i", "Ç", "ç", opts)
-- clears message area and also clears hl on Esc
vim.api.nvim_set_keymap("n", "<Esc>", ":nohl | echo ''<CR><Esc>", opts)
-- Save file
vim.api.nvim_set_keymap("n", "<leader>w", "<cmd>lua Format_Null_ls()<CR>", opts)

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
vim.api.nvim_set_keymap("n", "<C-l>", ":vertical resize +3<CR>", opts) -- Control+Left resizes vertical split +
vim.api.nvim_set_keymap("n", "<C-h>", ":vertical resize -3<CR>", opts) -- Control+Right resizes vertical split -

------BUFFERS------
-- buffer navigation, open and deleting
vim.api.nvim_set_keymap("n", "<leader>,", ":bn<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>.", ":bp<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>H", ":sp<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>V", ":vsp<CR>", opts)
-- Quitting buffer
vim.api.nvim_set_keymap("n", "gq", ":bd<CR>", opts)
vim.api.nvim_set_keymap("n", "gQ", ":bd!<CR>", opts)
-- Quitting vim
vim.api.nvim_set_keymap("n", "<leader>q", ":q<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>Q", ":q!<CR>", opts)

-- Visual Maps
-- Replace all instances of highlighted words
vim.api.nvim_set_keymap("v", "<leader>r", '"hy:%s/<C-r>h//g<left><left>', opts)

-- terminal mode
vim.api.nvim_set_keymap("t", "<esc>", "<c-\\><c-n><c-w><CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>T", ":vert term<CR>", opts)

-- other customizations
vim.api.nvim_set_keymap("n", "<leader>s", ":source %<CR>", opts)
-- create and goto file
vim.api.nvim_set_keymap("n", "<leader>cf", ":e <cfile><CR>", opts)
-- highlight all line on markdown files
vim.api.nvim_set_keymap("n", "<leader>*", "I==<Esc>A==<Esc>", opts)
-- highlight visual selected text on markdown files
vim.api.nvim_set_keymap("v", "<leader>*", 'c==<C-r>"<Esc>a==<Esc>', opts)
-- command and keymap to run REST API calls
vim.api.nvim_create_user_command("Rest", "vnew | read !sh #", {})
vim.api.nvim_set_keymap("n", "<leader>x", ":Rest<CR>", opts)
-- set nohl
vim.api.nvim_set_keymap("n", "-", ":nohl<CR>", opts)
