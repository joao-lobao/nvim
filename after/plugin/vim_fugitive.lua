local opts = { noremap = true, silent = true }

local function find_hunk(flag)
	local line = vim.fn.search("^M \\|^D \\|^? \\|^@@ \\|^Unpushed \\|^Unpulled ", flag or "")
	vim.api.nvim_command("normal! " .. line .. "G")
end

vim.api.nvim_create_user_command("FindHunkNext", function()
	find_hunk()
end, {})
vim.api.nvim_create_user_command("FindHunkPrev", function()
	find_hunk("b")
end, {})

local search_down_cmd = ":FindHunkNext<CR>"
local search_up_cmd = ":FindHunkPrev<CR>"
vim.api.nvim_set_keymap("n", "gs", ":G<CR>" .. search_down_cmd, opts)

vim.api.nvim_set_keymap("n", "gl", ":Gclog<CR>:b#<CR><C-w>j", opts)
vim.api.nvim_set_keymap("n", "g%", ":Gclog -- %<CR>:b#<CR><C-w>j", opts)
vim.api.nvim_set_keymap("n", "gb", ":Git blame<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>gh", ":diffget //2<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>gl", ":diffget //3<CR>", opts)

Browse_to_commit = function()
	local remote_origin = vim.fn.systemlist("git config --get remote.origin.url | sed -e 's/\\.git$//g'")[1]

	-- str under cursor
	local cfile = vim.fn.expand("<cword>")
	-- current file name
	local fname = vim.fn.expand("%:t")

	for _, hash in ipairs({ cfile, fname }) do
		if vim.fn.system("git cat-file -t " .. hash) == "commit\n" then
			return vim.api.nvim_command("silent !xdg-open " .. remote_origin .. "/commit/" .. hash)
		end
	end
	Notification("No commit hash found", vim.log.levels.ERROR)
end
-- open commit url from git log diff or hash under cursor
vim.api.nvim_set_keymap("n", "go", "<cmd>lua Browse_to_commit()<CR>", opts)

local group_fugitive = vim.api.nvim_create_augroup("CustomFugitiveMapping", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "fugitive", "git", "fugitiveblame" },
	callback = function()
		vim.api.nvim_buf_set_keymap(0, "n", "P", ":Git push", { noremap = true })
		vim.api.nvim_buf_set_keymap(0, "n", "fP", ":Git push --force", { noremap = true })
		vim.api.nvim_buf_set_keymap(0, "n", "p", ":Git pull", { noremap = true })
		vim.api.nvim_buf_set_keymap(0, "n", "fp", ":Git pull --force", { noremap = true })
		vim.api.nvim_buf_set_keymap(0, "n", "q", ":bd<CR>", opts)
		vim.api.nvim_buf_set_keymap(0, "n", "<Esc>", ":bd<CR>", opts)
		vim.api.nvim_buf_set_keymap(0, "n", "<C-k>", search_up_cmd, opts)
		vim.api.nvim_buf_set_keymap(0, "n", "<C-j>", search_down_cmd, opts)
	end,
	group = group_fugitive,
})

ToggleDiffView = function()
	if vim.o.diff == false then
		vim.api.nvim_command("Gdiffsplit")
		vim.api.nvim_buf_set_keymap(0, "n", "gp", "[c", opts)
		vim.api.nvim_buf_set_keymap(0, "n", "gn", "]c", opts)
		vim.api.nvim_buf_set_keymap(0, "n", "<Esc>", ":q<CR>", opts)
		vim.api.nvim_buf_set_keymap(0, "n", "gq", ":q<CR>", opts)
	else
		vim.api.nvim_command("q")
	end
end
vim.api.nvim_set_keymap("n", "vd", "<cmd>lua ToggleDiffView()<CR>", opts)

DiffTool = function()
	vim.cmd("Git difftool")
	if next(vim.fn.getqflist()) == nil then
		vim.cmd("cclose")
		Notification("No changes to show", vim.log.levels.INFO)
		return
	end
	vim.cmd("copen")
end
vim.api.nvim_set_keymap("n", "vt", "<cmd>lua DiffTool()<CR>", opts)

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

local hunk_line_number = function(diff, hunk_number)
	local cline_nlines_pair = string.sub(vim.split(diff[hunk_number], " ")[3], 2)
	return tonumber(vim.split(cline_nlines_pair, ",")[1])
end

-- goto previous and next hunk
Goto_hunk = function(direction)
	local path = vim.fn.expand("%:p")
	local diff = vim.fn.systemlist("git diff --unified=0 " .. path .. " | grep '^@@'")
	local cursor_line = vim.fn.line(".")

	if #diff == 0 then
		return Notification("No valid changes to move to", vim.log.levels.ERROR)
	end

	for i, _ in ipairs(diff) do
		-- iterate over changed hunks
		local line_number = hunk_line_number(diff, i)

		if direction == "down" then
			if line_number > cursor_line then
				vim.api.nvim_command("normal! " .. line_number .. "G")
				break
			elseif i == #diff then
				line_number = hunk_line_number(diff, 1)
				vim.api.nvim_command("normal! " .. line_number .. "G")
				break
			end
		end
		if direction == "up" then
			if line_number < cursor_line then
				vim.api.nvim_command("normal! " .. line_number .. "G")
			elseif i == 1 then
				line_number = hunk_line_number(diff, #diff)
				vim.api.nvim_command("normal! " .. line_number .. "G")
			end
		end
	end
end

vim.api.nvim_set_keymap("n", "gp", "<cmd>lua Goto_hunk('up')<CR>", opts)
vim.api.nvim_set_keymap("n", "gn", "<cmd>lua Goto_hunk('down')<CR>", opts)
