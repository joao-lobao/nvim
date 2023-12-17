local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "gs", ":G<CR>", opts)
vim.api.nvim_set_keymap("n", "gl", ":Gclog<CR><C-w>j", opts)
vim.api.nvim_set_keymap("n", "gb", ":Git blame<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>gh", ":diffget //2<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>gl", ":diffget //3<CR>", opts)
vim.api.nvim_create_user_command("GitLastCommit", "Git show -1", {})

ToggleDiffView = function()
	if vim.o.diff == false then
		vim.api.nvim_command("Gdiffsplit")
	else
		vim.api.nvim_command("q")
	end
end
vim.api.nvim_set_keymap("n", "vd", "<cmd>lua ToggleDiffView()<CR>", opts)

-- stage/reset hunks
StageHunk = function()
	local buffer_lines = vim.fn.line("$")
	local cursor_line = vim.fn.line(".")

	vim.api.nvim_command("Gdiffsplit")
	if cursor_line == buffer_lines then
		vim.api.nvim_command("normal! j")
	end
	vim.api.nvim_command("diffget")
	vim.api.nvim_command("w")
	vim.api.nvim_command("q")
end

ResetHunk = function()
	local buffer_lines = vim.fn.line("$")
	local cursor_line = vim.fn.line(".")

	vim.api.nvim_command("Gdiffsplit")
	if cursor_line == buffer_lines then
		vim.api.nvim_command("wincmd l")
		vim.api.nvim_command("normal! j")
		vim.api.nvim_command("diffget")
		vim.api.nvim_command("w")
		vim.api.nvim_command("wincmd h")
	else
		vim.api.nvim_command("diffput")
		vim.api.nvim_command("w")
	end
	vim.api.nvim_command("q")
end
vim.api.nvim_set_keymap("n", "<leader>gu", "<cmd>lua ResetHunk()<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>gs", "<cmd>lua StageHunk()<CR>", opts)

-- goto previous and next hunk
Goto_prev_hunk = function()
	vim.api.nvim_command("Gdiffsplit")
	vim.api.nvim_command("normal! [c")
	vim.api.nvim_command("q")
end
Goto_next_hunk = function()
	vim.api.nvim_command("Gdiffsplit")
	vim.api.nvim_command("normal! ]c")
	vim.api.nvim_command("q")
end
vim.api.nvim_set_keymap("n", "gp", "<cmd>lua Goto_prev_hunk()<CR>", opts)
vim.api.nvim_set_keymap("n", "gn", "<cmd>lua Goto_next_hunk()<CR>", opts)
