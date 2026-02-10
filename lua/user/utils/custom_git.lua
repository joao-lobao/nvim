-- Custom Git Gutter
-- define signs
vim.api.nvim_command("sign define diffadd text=+ texthl=DiffAdd")
vim.api.nvim_command("sign define diffdelete text=󰾞 texthl=DiffDelete")
vim.api.nvim_set_hl(0, "DiffText", { bg = Green, fg = Dark_gray })

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
	vim.api.nvim_command("sign place " .. line_nr .. " line=" .. line_nr .. " name=" .. get_type(line))
end

local is_real_file_buffer = function(buf)
	local bo = vim.bo[buf]

	-- 1. Must be a normal file buffer
	if bo.buftype ~= "" then
		return false
	end

	-- 2. Must have a name (rules out [No Name], plugin buffers, etc)
	local name = vim.api.nvim_buf_get_name(buf)
	if name == "" then
		return false
	end

	-- 3. Must not be a directory
	if vim.fn.isdirectory(name) == 1 then
		return false
	end

	return true
end

local is_git_working_file = function(buf)
	if not is_real_file_buffer(buf) then
		return false
	end

	local name = vim.api.nvim_buf_get_name(buf)
	local dir = vim.fn.fnamemodify(name, ":h")

	-- find git root upward from the file's directory
	local git_root = vim.fn.finddir(".git", dir .. ";")
	if git_root == "" then
		return false
	end

	return true
end

Get_git_info = function()
	local msg_char_limit = 72
	local is_git_repo = is_git_working_file(0)
	if is_git_repo then
		local git_branch = "-- " .. string.gsub(vim.fn.system("git branch --show-current"), "\n", "")
		local git_message = "-- "
			.. string.sub(string.gsub(vim.fn.system("git show -s --format=%s"), "\n", ""), 1, msg_char_limit)
		local git_status = " --"
			.. string.sub(string.gsub(vim.fn.system("git diff --shortstat"), "\n", ""), 1, msg_char_limit)
		vim.notify(git_branch .. " " .. git_message .. git_status, vim.log.levels.INFO)
		return
	end
	vim.notify("Not a git repo", vim.log.levels.ERROR)
end
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "gi", "<cmd>lua Get_git_info()<CR>", opts)
vim.api.nvim_set_keymap("n", "gh", ":e ~/.config/nvim/lua/user/utils/git_commit_msg_help.txt<CR>", opts)

SetDiffSigns = function()
	local path = vim.fn.expand("%:p")
	local diff = vim.fn.systemlist("git diff --unified=0 " .. path)
	-- sign unplace on current buffer
	vim.api.nvim_command("sign unplace * file=" .. path .. "")

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
	callback = function(args)
		if is_git_working_file(args.buf) then
			SetDiffSigns()
		end
	end,
	group = group_git,
})
