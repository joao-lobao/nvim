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
	vim.cmd("copen")
	vim.fn.search(buf_name)
end

local search = {
	project = { git = "git ls-files", no_git = "find . -type f -name '*' ! -path '*node_modules*'" },
	all = { git = "git ls-files --cached --others", no_git = "find . -type f -name '*'" },
}

local get_home_files = function(pattern)
	local home_files =
		-- find all files and directories in the home directory
		-- ~ is the home directory
		-- -type f,d (file or directory)
		-- -name '*pattern*' (search for files or directories with the pattern)
		-- ! -path '*node_modules*' (exclude node_modules directory)
		-- ! -path '*.git/*' (exclude .git directory)
		vim.fn.systemlist("find ~ -type f,d -name '*" .. pattern .. "*' ! -path '*node_modules*' ! -path '*.git/*'")
	return home_files
end

local get_files = function(scope)
	local search_scope_vsc = Is_git_repo() and search[scope].git or search[scope].no_git
	return vim.fn.systemlist(search_scope_vsc)
end

Files = function(type)
	local pattern = vim.fn.tolower(vim.fn.input("Search file: ", "", "file"))

	local files = type == "home" and get_home_files(pattern) or get_files(type)
	local results = {}
	for _, g_file in ipairs(files) do
		if vim.fn.tolower(g_file):find(pattern) then
			local file = { filename = g_file }
			table.insert(results, file)
		end
	end

	if #results == 0 then
		Notification("No files found", vim.log.levels.INFO)
		return
	elseif #results == 1 then
		vim.cmd("edit " .. results[1].filename)
		return
	end

	vim.fn.setqflist(results)
	vim.cmd("copen")
end

Grep = function(params)
	params = params or ""

	local pattern = vim.fn.input("Search pattern: ")
	-- -i (ignore case)
	-- --vimgrep (output format, a line with more than one match will be printed more than once)
	-- --hidden (search hidden files)
	-- --glob '!.git' (excludes the .git directory)
	local grep = vim.fn.systemlist("rg -i --vimgrep --hidden " .. params .. " --glob '!.git' '" .. pattern .. "'")
	if pattern == "" or #grep == 0 then
		Notification("No results to show", vim.log.levels.ERROR)
		return
	end

	local matches = {}
	for _, rg_match in ipairs(grep) do
		local file, line, col, text = rg_match:match("([^:]+):(%d+):(%d+):(.*)")
		table.insert(matches, { filename = file, lnum = line, col = col, text = text })
	end

	vim.fn.setqflist(matches)
	vim.cmd("copen")
end

Oldfiles = function()
	local oldfiles = vim.api.nvim_exec2("filter /\\v^(fugitive|.*fugitiveblame$)@!/ oldfiles", { output = true })
	oldfiles = vim.split(oldfiles.output, "\n")
	local files = {}

	local pattern = vim.fn.tolower(vim.fn.input("Search file: "))
	for _, o_file in ipairs(oldfiles) do
		local fname = vim.split(o_file, ": ")[2]
		if fname ~= nil and vim.fn.tolower(fname):find(pattern) then
			local file = { filename = fname }
			table.insert(files, file)
		end
	end

	if #files == 0 then
		Notification("No files found", vim.log.levels.INFO)
		return
	elseif #files == 1 then
		vim.cmd("edit " .. files[1].filename)
		return
	end

	vim.fn.setqflist(files)
	vim.cmd("copen")
end

Diagnostics = function()
	if #vim.diagnostic.get() == 0 then
		Notification("No diagnostics found", vim.log.levels.INFO)
		return
	end
	vim.diagnostic.setqflist()
	vim.cmd("copen")
end

Eslint_to_qflist = function()
	-- this can be also achieved by having a lint script in package.json and calling 'npm run lint' in here
	local eslint = vim.fn.systemlist("eslint . -f ~/.config/nvim/lua/user/utils/custom_formatter.cjs")
	local decode_eslint_result = function()
		return vim.json.decode(eslint[1])
	end

	-- error handling
	if not pcall(decode_eslint_result) then
		Notification("No eslint configuration", vim.log.levels.ERROR)
		return
	end

	local diagnostics = decode_eslint_result()

	local lints = {}
	local severity = { s2 = "E", s1 = "W" }
	for _, diag in ipairs(diagnostics) do
		table.insert(lints, {
			type = severity["s" .. diag.severity] or "N",
			filename = diag.filename,
			lnum = diag.lnum,
			col = diag.col,
			text = diag.text,
		})
	end
	if #lints == 0 then
		Notification("No linting errors found", vim.log.levels.INFO)
		return
	end
	vim.fn.setqflist(lints)
	vim.cmd("copen")
end

local opts = { noremap = true, silent = false }
-- git/project files
-- vim.api.nvim_set_keymap("n", "<leader><leader>f", "<cmd>lua Files('project')<CR>", opts)
-- all files
-- vim.api.nvim_set_keymap("n", "<leader><leader>F", "<cmd>lua Files('all')<CR>", opts)
-- home files
-- vim.api.nvim_set_keymap("n", "<leader><leader>h", "<cmd>lua Files('home')<CR>", opts)
-- git grep
-- vim.api.nvim_set_keymap("n", "<leader><leader>g", "<cmd>lua Grep()<CR>", opts)
-- all grep
-- vim.api.nvim_set_keymap("n", "<leader><leader>G", "<cmd>lua Grep('--no-ignore')<CR>", opts)
-- others
-- vim.api.nvim_set_keymap("n", "tf", ":find *", opts) -- to find hidden files have to replace "*" for ".*"
-- vim.api.nvim_set_keymap("n", "th", ":find ~/", opts)
-- vim.api.nvim_set_keymap("n", "tg", ":vim  **/* **/.*<C-Left><C-Left><Left>", opts) -- use f as /test/f for fuzzy or \C as test\C for case sensitive search
-- vim.api.nvim_set_keymap("n", "tb", ":buffers<CR>:b", opts)
-- vim.api.nvim_set_keymap("n", "to", ":browse filter ** oldfiles<C-Left><Left><Left>", opts)
vim.api.nvim_set_keymap("n", "tb", "<cmd>lua ListedBuffers()<CR>", opts)
-- vim.api.nvim_set_keymap("n", "<leader>o", "<cmd>lua Oldfiles()<CR>", opts)
vim.api.nvim_set_keymap("n", "td", "<cmd>lua Diagnostics()<CR>", opts)
vim.api.nvim_set_keymap("n", "tE", "<cmd>lua Eslint_to_qflist()<CR>", opts)
-- open quickfix list
vim.api.nvim_set_keymap("n", "co", ":copen<CR>", opts)
vim.api.nvim_set_keymap("n", "cc", ":cclose<CR>", opts)
vim.api.nvim_set_keymap("n", "cn", ":cnext<CR>", opts)
vim.api.nvim_set_keymap("n", "cp", ":cprev<CR>", opts)
