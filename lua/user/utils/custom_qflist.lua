local is_qf_open = function()
	local quickfix_window = vim.fn.getqflist({ winid = 1 }).winid
	return quickfix_window ~= 0
end

local open_list_and_notify = function(results)
	if #results == 0 then
		Notification("No results found", vim.log.levels.WARN)
		return
	end
	vim.fn.setqflist(results)
	vim.cmd("copen")
	vim.notify(#results .. " results found", vim.log.levels.INFO)
end

ListedBuffers = function()
	if is_qf_open() then
		vim.cmd("cclose")
		return
	end

	local buf_name = vim.fn.expand("%:f")
	local results = {}
	local opened_bufs = vim.fn.getbufinfo({ buflisted = 1 })
	for _, buf in ipairs(opened_bufs) do
		-- display buffer number on quickfix list item
		buf["text"] = buf.bufnr
		table.insert(results, buf)
	end
	open_list_and_notify(results)
	vim.fn.search(buf_name)
end

local get_files_from = function(dir, pattern)
	local pat = "*" .. pattern .. "*"

	return {
		prune = vim.fn.systemlist({
			"find",
			vim.fn.expand(dir),
			"(",
			"-path",
			"*/node_modules/*",
			"-o",
			"-path",
			"*/.git/*",
			")",
			"-prune",
			"-o",
			"-ipath",
			pat,
			"-print",
		}),
		no_prune = vim.fn.systemlist({
			"find",
			vim.fn.expand(dir),
			"-ipath",
			pat,
			"-print",
		}),
	}
end

Files = function(dir, prune)
	if dir == nil or dir == "" then
		dir = vim.fn.getcwd()
	end
	if prune == nil or prune == "" then
		prune = "prune"
	end

	local pattern = vim.fn.tolower(vim.fn.input("Search file: ", vim.fn.expand(dir) .. "**/*", "file"))
	if pattern == "" then
		return
	end

	local files = get_files_from(dir, pattern)[prune]
	local results = {}

	for _, g_file in ipairs(files) do
		table.insert(results, { filename = g_file })
	end

	if #results == 1 then
		vim.cmd("edit " .. results[1].filename)
		return
	end

	open_list_and_notify(results)
end

Grep = function(params)
	params = params or ""

	local pattern = vim.fn.input("Grep pattern: ")
	if pattern == "" then
		return
	end
	-- -i (ignore case)
	-- --vimgrep (output format, a line with more than one match will be printed more than once)
	-- --hidden (search hidden files)
	-- --glob '!.git' (excludes the .git directory)
	local grep = vim.fn.systemlist("rg -i --vimgrep --hidden " .. params .. " --glob '!.git' '" .. pattern .. "'")
	if #grep == 0 then
		Notification("No matches found", vim.log.levels.ERROR)
		return
	end

	local results = {}
	for _, rg_match in ipairs(grep) do
		local file, line, col, text = rg_match:match("([^:]+):(%d+):(%d+):(.*)")
		table.insert(results, { filename = file, lnum = line, col = col, text = text })
	end

	open_list_and_notify(results)
end

Oldfiles = function()
	local oldfiles = vim.api.nvim_exec2("filter /\\v^(fugitive|.*fugitiveblame$)@!/ oldfiles", { output = true })
	oldfiles = vim.split(oldfiles.output, "\n")
	local results = {}

	local pattern = vim.fn.tolower(vim.fn.input("Oldfiles pattern: "))
	if pattern == "" then
		return
	end

	for _, o_file in ipairs(oldfiles) do
		local fname = vim.split(o_file, ": ")[2]
		if fname ~= nil and vim.fn.tolower(fname):find(pattern) then
			local file = { filename = fname }
			table.insert(results, file)
		end
	end

	if #results == 1 then
		vim.cmd("edit " .. results[1].filename)
		return
	end

	open_list_and_notify(results)
end

Diagnostics = function()
	vim.diagnostic.setqflist()
	vim.notify(#vim.diagnostic.get() .. " diagnostics found", vim.log.levels.INFO)
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

	local results = {}
	local severity = { s2 = "E", s1 = "W" }
	for _, diag in ipairs(diagnostics) do
		table.insert(results, {
			type = severity["s" .. diag.severity] or "N",
			filename = diag.filename,
			lnum = diag.lnum,
			col = diag.col,
			text = diag.text,
		})
	end

	open_list_and_notify(results)
end

Mappings = function()
	local results = {}

	local pattern = vim.fn.input("Mappings pattern: ")
	if pattern == "" then
		return
	end

	local keys = vim.api.nvim_get_keymap("n")

	for _, key in ipairs(keys) do
		local left = key["lhs"]:lower():find(pattern:lower())
		-- check key["lhs"] starts with a space
		if key["lhs"]:sub(1, 1) == " " then
			key["lhs"] = "<leader>" .. key["lhs"]:sub(2)
		end

		if key["rhs"] == nil then
			key["rhs"] = ""
		else
			key["rhs"] = key["rhs"]:gsub("|", "")
		end

		local right = key["rhs"]:lower():find(pattern:lower())

		if not (left == nil) or not (right == nil) then
			table.insert(results, 1, { filename = key["lhs"], pattern = key["rhs"] })
		end
	end

	open_list_and_notify(results)
end

local opts = { noremap = true, silent = false }
-- git/project files
vim.api.nvim_set_keymap("n", "tf", "<cmd>lua Files()<CR>", opts)
-- all files
vim.api.nvim_set_keymap("n", "tF", "<cmd>lua Files('', 'no_prune')<CR>", opts)
-- home files
vim.api.nvim_set_keymap("n", "th", "<cmd>lua Files('~')<CR>", opts)
-- git grep
vim.api.nvim_set_keymap("n", "tg", "<cmd>lua Grep()<CR>", opts)
-- all grep
vim.api.nvim_set_keymap("n", "tG", "<cmd>lua Grep('--no-ignore')<CR>", opts)
-- keymaps
vim.api.nvim_set_keymap("n", "tk", "<cmd>lua Mappings()<CR>", opts)
-- others
-- vim.api.nvim_set_keymap("n", "tf", ":find *", opts) -- to find hidden files have to replace "*" for ".*"
-- vim.api.nvim_set_keymap("n", "th", ":find ~/", opts)
-- vim.api.nvim_set_keymap("n", "tg", ":vim  **/* **/.*<C-Left><C-Left><Left>", opts) -- use f as /test/f for fuzzy or \C as test\C for case sensitive search
-- vim.api.nvim_set_keymap("n", "tb", ":buffers<CR>:b", opts)
-- vim.api.nvim_set_keymap("n", "to", ":browse filter ** oldfiles<C-Left><Left><Left>", opts)
vim.api.nvim_set_keymap("n", "tb", "<cmd>lua ListedBuffers()<CR>", opts)
vim.api.nvim_set_keymap("n", "to", "<cmd>lua Oldfiles()<CR>", opts)
vim.api.nvim_set_keymap("n", "td", "<cmd>lua Diagnostics()<CR>", opts)
vim.api.nvim_set_keymap("n", "te", "<cmd>lua Eslint_to_qflist()<CR>", opts)
-- open quickfix list
vim.api.nvim_set_keymap("n", "co", ":copen<CR>", opts)
vim.api.nvim_set_keymap("n", "cc", ":cclose<CR>", opts)
vim.api.nvim_set_keymap("n", "cn", ":cnext<CR>", opts)
vim.api.nvim_set_keymap("n", "cp", ":cprev<CR>", opts)
