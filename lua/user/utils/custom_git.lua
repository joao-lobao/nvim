-- Custom Git Gutter
-- define signs
vim.api.nvim_command("sign define diffadd text=+ texthl=DiffAdd")
vim.api.nvim_command("sign define diffdelete text=󰾞 texthl=DiffDelete")

local get_type = function(line)
	if vim.startswith(line, "+") then
		return "diffadd"
	else
		return "diffdelete"
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
IsBufferEligibleForSigning = function()
	-- is file inside a git project
	local file_dir = vim.fn.expand("%:p:h")
	local is_file_in_git_project = vim.fn.system("git -C " .. file_dir .. " rev-parse --is-inside-work-tree")
		== "true\n"
	-- is buffer in diff mode
	local is_diff_mode = vim.api.nvim_command_output([[echo &diff]]) == "1"
	return is_file_in_git_project and not is_diff_mode and vim.bo.filetype ~= ""
end

SetDiffSigns = function()
	local path = vim.fn.expand("%:p")
	local diff = vim.fn.systemlist("git diff --unified=0 " .. path)
	-- sign unplace on current buffer
	vim.api.nvim_command("sign unplace 1 group=* file=" .. path .. "")

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

-- create autocommands group so they can be cleared later
local group_git = vim.api.nvim_create_augroup("CustomGit", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
	callback = function()
		if IsBufferEligibleForSigning() then
			SetDiffSigns()
		end
	end,
	group = group_git,
})
