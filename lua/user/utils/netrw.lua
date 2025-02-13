vim.g.netrw_banner = 0
vim.g.netrw_localcopydircmd = "cp -r" -- to enable copy directories recursively
vim.g.netrw_keepdir = 0 -- fixes the netrw bug move back again files already moved
-- vim.g.netrw_liststyle = 3 -- show tree style
vim.g.netrw_fastbrowse = 0 -- solution to netrw leaving buffers open

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<leader>e", ":Ex<CR>", opts)
