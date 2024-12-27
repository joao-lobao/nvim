local is_qf_open = function()
	local quickfix_window = vim.fn.getqflist({ winid = 1 }).winid
	return quickfix_window ~= 0
end

ListedBuffers = function()
	if is_qf_open() then
		vim.cmd("cclose")
		return
	end

	local buf_name = vim.fn.expand("%:f")
	local buffers = {}
	local opened_bufs = vim.fn.getbufinfo({ buflisted = 1 })
	for _, buf in ipairs(opened_bufs) do
		-- display buffer number on quickfix list item
		buf["text"] = buf.bufnr
		table.insert(buffers, buf)
	end
	vim.fn.setqflist(buffers)
	vim.cmd("copen " .. #opened_bufs)
	vim.fn.search(buf_name)
end

local search = {
	project = { git = "git ls-files", no_git = "find . -type f -name '*' ! -path '*node_modules*'" },
	all = { git = "git ls-files --cached --others", no_git = "find . -type f -name '*'" },
}

local getFiles = function(type)
	local is_file_in_git_project = vim.fn.system("git -C . rev-parse --is-inside-work-tree") == "true\n"
	if is_file_in_git_project then
		return vim.fn.systemlist(search[type].git)
	end
	-- in case not a git repo
	return vim.fn.systemlist(search[type].no_git)
end

Files = function(type)
	local files = getFiles(type)
	local results = {}
	for _, g_file in ipairs(files) do
		local file = { filename = g_file }
		table.insert(results, file)
	end
	vim.fn.setqflist(results)
	vim.cmd("copen")
end

Grep = function(params)
	params = params or ""
	local pattern = vim.fn.input("Search pattern: ")
	local git_grep = vim.fn.systemlist("rg -i --vimgrep --hidden " .. params .. " --glob '!.git' '" .. pattern .. "'")
	if pattern == "" then
		vim.notify("Exited Grep", vim.log.levels.WARN)
		Notification("Exited Grep", vim.log.levels.WARN)
		return
	elseif #git_grep == 0 then
		vim.notify(" No results found", vim.log.levels.WARN)
		Notification("No results found", vim.log.levels.ERROR)
		return
	end

	local matches = {}
	for _, rg_match in ipairs(git_grep) do
		local file, line, col, text = rg_match:match("([^:]+):(%d+):(%d+):(.*)")
		table.insert(matches, { filename = file, lnum = line, col = col, text = text })
	end

	vim.fn.setqflist(matches)
	vim.cmd("copen")
end

Oldfiles = function()
	local oldfiles = vim.api.nvim_exec2("oldfiles", { output = true })
	oldfiles = vim.split(oldfiles.output, "\n")
	local files = {}
	for _, o_file in ipairs(oldfiles) do
		local file = { filename = vim.split(o_file, ": ")[2] }
		table.insert(files, file)
	end
	vim.fn.setqflist(files)
	vim.cmd("copen")
end

Diagnostics = function()
	vim.diagnostic.setqflist()
	vim.cmd("copen")
end

local opts = { noremap = true, silent = false }
-- git/project files
vim.api.nvim_set_keymap("n", "<leader><leader>", "<cmd>lua Files('project')<CR>", opts)
-- all files
vim.api.nvim_set_keymap("n", "<leader>F", "<cmd>lua Files('all')<CR>", opts)
-- git grep
vim.api.nvim_set_keymap("n", "<leader>r", "<cmd>lua Grep()<CR>", opts)
-- all grep
vim.api.nvim_set_keymap("n", "<leader>R", "<cmd>lua Grep('--no-ignore')<CR>", opts)
-- others
vim.api.nvim_set_keymap("n", "<leader>B", "<cmd>lua ListedBuffers()<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>o", "<cmd>lua Oldfiles()<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>d", "<cmd>lua Diagnostics()<CR>", opts)
