vim.g.netrw_banner = 0
vim.g.netrw_localcopydircmd = "cp -r" -- to enable copy directories recursively
vim.g.netrw_keepdir = 0 -- fixes the netrw bug move back again files already moved
-- vim.g.netrw_liststyle = 3 -- show tree style

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<leader>e", ":Ex<CR>", opts)

-- create autocommand to set keymaps on specific filetype
local group_netrw = vim.api.nvim_create_augroup("CustomNetrwMapping", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	pattern = "netrw",
	callback = function()
		vim.api.nvim_buf_set_keymap(0, "n", "l", ":e <cfile><CR>", opts)
		vim.api.nvim_buf_set_keymap(0, "n", "gq", ":Rex<CR>", opts)
	end,
	group = group_netrw,
})
