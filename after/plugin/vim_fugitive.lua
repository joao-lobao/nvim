local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "gs", ":G<CR>", opts)

vim.api.nvim_set_keymap("n", "gl", ":Gclog<CR><C-w>j", opts)
vim.api.nvim_set_keymap("n", "g%", ":Gclog -- %<CR><C-w>j", opts)

vim.api.nvim_set_keymap("n", "<leader>gd", ":Gdiffsplit<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>gh", ":diffget //2<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>gl", ":diffget //3<CR>", opts)

vim.api.nvim_set_keymap("n", "gb", ":Git blame<CR>", opts)

-- get last commit message
vim.api.nvim_create_user_command("GitLastCommit", "Git show -1", {})

-- hunks navigation
ToggleDiffView = function()
	if vim.o.diff == false then
		vim.api.nvim_command("Gdiffsplit")
	else
		vim.api.nvim_command("q")
	end
end

vim.api.nvim_set_keymap("n", "vd", "<cmd>lua ToggleDiffView()<CR>", opts)
