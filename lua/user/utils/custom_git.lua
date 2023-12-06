-- stage/reset hunks
local opts = { noremap = true, silent = true }
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
vim.api.nvim_set_keymap("n", "<leader>gp", "<cmd>lua Goto_prev_hunk()<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>gn", "<cmd>lua Goto_next_hunk()<CR>", opts)

-- Custom Git Gutter
-- define signs
vim.api.nvim_command("sign define diffchange text=| texthl=GruvboxAquaBold")
vim.api.nvim_command("sign define diffadd text=| texthl=GruvboxGreenBold")
vim.api.nvim_command("sign define diffdelete text=| texthl=GruvboxRedBold")

local get_type = function(line)
	if vim.startswith(line, "+") then
		return "diffadd"
	elseif vim.startswith(line, "-") then
		return "diffdelete"
	else
		return "diffchange"
	end
end

local sign_line = function(line_number, line)
	local line_nr = tonumber(line_number)
	if line_nr == 0 then
		line_nr = 1
	end
	vim.api.nvim_command("sign place 1 line=" .. line_nr .. " name=" .. get_type(line))
end

-- check buffer is a file in a git project
local is_file_inside_a_git_project = function()
	local file_dir = vim.fn.expand("%:p:h")
	return vim.fn.system("git -C " .. file_dir .. " rev-parse --is-inside-work-tree") == "true\n"
end

SetDiffSigns = function()
	if not is_file_inside_a_git_project() then
		return
	end

	vim.api.nvim_command("call sign_unplace('')")
	local path = vim.fn.expand("%:p")
	local diff = vim.fn.systemlist("git diff --unified=0 " .. path)

	-- iterate over changed hunks
	for index, line in ipairs(diff) do
		if vim.startswith(line, "@@") then
			local cline_nlines_pair = string.sub(vim.split(line, " ")[3], 2)
			local line_number = vim.split(cline_nlines_pair, ",")[1]
			local nr_of_lines = vim.split(cline_nlines_pair, ",")[2]

			-- check change is one line only
			if nr_of_lines == nil or nr_of_lines == "0" then
				sign_line(line_number, diff[index + 1])
			else
				-- sign when multiple lines are changed
				for i = 1, nr_of_lines do
					sign_line(line_number + i - 1, diff[index + 1])
				end
			end
		end
	end
end

-- autocommands
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
	callback = function()
		SetDiffSigns()
	end,
})
