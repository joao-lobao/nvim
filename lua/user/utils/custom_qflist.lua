local open_list_and_notify = function(results)
	local msg = " - " .. #results .. " "
	if #results > 0 then
		vim.fn.setqflist(results)
		vim.cmd("copen")
		msg = #results .. " "
	end
	msg = msg .. "results found"
	vim.notify(msg, vim.log.levels.INFO)
end

ListedBuffers = function()
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

local get_files_from = function(dir, pattern, params)
	return vim.fn.systemlist("rg --files --hidden " .. params .. " " .. dir .. " | rg -i " .. pattern)
end

Files = function(dir, params)
	if dir == nil or dir == "" then
		dir = vim.fn.getcwd()
	end
	if params == nil then
		params = ""
	end

	local pattern = vim.fn.tolower(vim.fn.input("Search file: "))
	if pattern ~= "" then
		local files = get_files_from(dir, pattern, params)
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
end

Grep = function(params)
	params = params or ""

	local string = vim.fn.input("Grep pattern: ")
	if string ~= "" then
		-- -i (ignore case)
		-- --vimgrep (output format, a line with more than one match will be printed more than once)
		-- --hidden (search hidden files)
		-- --fixed-strings (treat pattern as a literal string instead of a regex)
		local grep = vim.fn.systemlist("rg -i --vimgrep --hidden --fixed-strings " .. params .. ' "' .. string .. '"')

		local results = {}
		for _, rg_match in ipairs(grep) do
			local file, line, col, text = rg_match:match("([^:]+):(%d+):(%d+):(.*)")
			table.insert(results, { filename = file, lnum = line, col = col, text = text })
		end

		open_list_and_notify(results)
	end
end

Oldfiles = function()
	local oldfiles = vim.api.nvim_exec2("filter /\\v^(fugitive|.*fugitiveblame$)@!/ oldfiles", { output = true })
	oldfiles = vim.split(oldfiles.output, "\n")
	local results = {}

	local pattern = vim.fn.tolower(vim.fn.input("Oldfiles pattern: "))
	if pattern ~= "" then
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
		vim.notify("No eslint configuration", vim.log.levels.ERROR)
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
	if pattern ~= "" then
		local keys = {}
		vim.list_extend(keys, vim.api.nvim_get_keymap("n"))
		vim.list_extend(keys, vim.api.nvim_get_keymap("v"))
		vim.list_extend(keys, vim.api.nvim_get_keymap("i"))

		for _, key in ipairs(keys) do
			local left = key["lhs"]:lower():find(pattern:lower(), 1, true)
			-- check key["lhs"] starts with a space
			if key["lhs"]:sub(1, 1) == " " then
				key["lhs"] = "<leader>" .. key["lhs"]:sub(2)
			end

			if key["rhs"] == nil then
				key["rhs"] = ""
			else
				key["rhs"] = key["rhs"]:gsub("|", "")
			end

			local right = key["rhs"]:lower():find(pattern:lower(), 1, true)

			if not (left == nil) or not (right == nil) then
				table.insert(results, 1, { filename = key["lhs"], text = key["mode"], pattern = key["rhs"] })
			end
		end

		open_list_and_notify(results)
	end
end

local opts = { noremap = true, silent = false }
-- git/project files
vim.api.nvim_set_keymap(
	"n",
	"tf",
	'<cmd>lua Files(\'\', \'-g "!node_modules" -g "!dist" -g "!build" -g "!.git"\')<CR>',
	opts
)
-- all files
vim.api.nvim_set_keymap("n", "tF", "<cmd>lua Files('', '--no-ignore -g \"!.git\"')<CR>", opts)
-- home files
vim.api.nvim_set_keymap(
	"n",
	"th",
	'<cmd>lua Files(\'~\', \'-g "!.npm" -g "!.nvm" -g "!.cache" -g "!node_modules" -g "!dist" -g "!build" -g "!.git" -g "!**/.local/state/**"\')<CR>',
	opts
)
-- git grep
vim.api.nvim_set_keymap("n", "tg", '<cmd>lua Grep(\'-g "!node_modules" -g "!dist" -g "!build" -g "!.git"\')<CR>', opts)
-- all grep
vim.api.nvim_set_keymap("n", "tG", "<cmd>lua Grep('--no-ignore -g \"!.git\"')<CR>", opts)
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
