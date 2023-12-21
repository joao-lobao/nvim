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
		vim.api.nvim_buf_set_keymap(0, "n", "gp", "[c", opts)
		vim.api.nvim_buf_set_keymap(0, "n", "gn", "]c", opts)
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
Goto_hunk = function(direction)
	local path = vim.fn.expand("%:p")
	local diff = vim.fn.systemlist("git diff --unified=0 " .. path .. " | grep '^@@'")
	local cursor_line = vim.fn.line(".")
	for _, line in ipairs(diff) do
		-- iterate over changed hunks
		local cline_nlines_pair = string.sub(vim.split(line, " ")[3], 2)
		local line_number = tonumber(vim.split(cline_nlines_pair, ",")[1])
		if line_number > cursor_line and direction == "down" then
			vim.api.nvim_command("normal! " .. line_number .. "G")
			break
		end
		if line_number < cursor_line and direction == "up" then
			vim.api.nvim_command("normal! " .. line_number .. "G")
		end
	end
end
vim.api.nvim_set_keymap("n", "gp", "<cmd>lua Goto_hunk('up')<CR>", opts)
vim.api.nvim_set_keymap("n", "gn", "<cmd>lua Goto_hunk('down')<CR>", opts)
