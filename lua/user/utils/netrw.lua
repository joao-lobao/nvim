vim.g.netrw_banner = 0
vim.g.netrw_localcopydircmd = "cp -r" -- to enable copy directories recursively
vim.g.netrw_keepdir = 0 -- fixes the netrw bug move back again files already moved
-- vim.g.netrw_liststyle = 3 -- show tree style
vim.g.netrw_fastbrowse = 0 -- solution to netrw leaving buffers open

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<leader>e", ":Ex<CR>", opts)

-- create autocommand to set keymaps on specific filetype
local group_netrw = vim.api.nvim_create_augroup("CustomNetrwMapping", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	pattern = "netrw",
	callback = function()
		vim.api.nvim_buf_set_keymap(0, "n", "l", ":e <cfile><CR>", opts)
		vim.api.nvim_buf_set_keymap(0, "n", "h", ":Ex ..<CR>", opts)
		vim.api.nvim_buf_set_keymap(0, "n", "gq", ":Rex<CR>", opts)
		vim.api.nvim_buf_set_keymap(0, "n", "<Esc>", ":Rex<CR>", opts)
		vim.api.nvim_buf_set_keymap(0, "n", "q", ":Rex<CR>", opts)
		-- deletes unused keymaps so that they don't conflict with "q" keymap
		vim.api.nvim_buf_del_keymap(0, "n", "qF")
		vim.api.nvim_buf_del_keymap(0, "n", "qL")
		vim.api.nvim_buf_del_keymap(0, "n", "qb")
		vim.api.nvim_buf_del_keymap(0, "n", "qf")
	end,
	group = group_netrw,
})
