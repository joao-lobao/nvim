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

local getFiles = function(scope)
	local search_scope_vsc = Is_git_repo() and search[scope].git or search[scope].no_git
	return vim.fn.systemlist(search_scope_vsc)
end

Files = function(type)
	local files = getFiles(type)
	local results = {}

	local pattern = vim.fn.input("Search file: ", "", "file")
	for _, g_file in ipairs(files) do
		if g_file:find(pattern) then
			local file = { filename = g_file }
			table.insert(results, file)
		end
	end
	vim.fn.setqflist(results)
	vim.cmd("copen")
end

Grep = function(params)
	params = params or ""

	local scope = "all"
	if params == "" then
		scope = "project/git"
	end

	local pattern = vim.fn.input("Search pattern in " .. scope .. " files: ")
	-- -i (ignore case)
	-- --vimgrep (output format, a line with more than one match will be printed more than once)
	-- --hidden (search hidden files)
	-- --glob '!.git' (excludes the .git directory)
	local git_grep = vim.fn.systemlist("rg -i --vimgrep --hidden " .. params .. " --glob '!.git' '" .. pattern .. "'")
	if pattern == "" then
		Notification("Exited Grep", vim.log.levels.WARN)
		return
	elseif #git_grep == 0 then
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
	local oldfiles = vim.api.nvim_exec2("filter /\\v^(fugitive|.*fugitiveblame$)@!/ oldfiles", { output = true })
	oldfiles = vim.split(oldfiles.output, "\n")
	local files = {}

	local pattern = vim.fn.input("Search file: ")
	for _, o_file in ipairs(oldfiles) do
		local fname = vim.split(o_file, ": ")[2]
		if fname ~= nil and fname:find(pattern) then
			local file = { filename = fname }
			table.insert(files, file)
		end
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
	local home_path = vim.fn.expand("$HOME/")
	-- this can be also achieved by having a lint script in package.json and calling 'npm run lint' in here
	local eslint = vim.fn.systemlist("eslint . -f " .. home_path .. ".config/nvim/lua/user/utils/custom_formatter.cjs")
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
-- git grep
-- vim.api.nvim_set_keymap("n", "<leader><leader>g", "<cmd>lua Grep()<CR>", opts)
-- all grep
-- vim.api.nvim_set_keymap("n", "<leader><leader>G", "<cmd>lua Grep('--no-ignore')<CR>", opts)
-- others
vim.api.nvim_set_keymap("n", "tb", "<cmd>lua ListedBuffers()<CR>", opts)
-- vim.api.nvim_set_keymap("n", "<leader>o", "<cmd>lua Oldfiles()<CR>", opts)
vim.api.nvim_set_keymap("n", "td", "<cmd>lua Diagnostics()<CR>", opts)
vim.api.nvim_set_keymap("n", "tE", "<cmd>lua Eslint_to_qflist()<CR>", opts)
-- open quickfix list
vim.api.nvim_set_keymap("n", "co", ":copen<CR>", opts)
vim.api.nvim_set_keymap("n", "cc", ":cclose<CR>", opts)
vim.api.nvim_set_keymap("n", "cn", ":cnext<CR>", opts)
vim.api.nvim_set_keymap("n", "cp", ":cprev<CR>", opts)
