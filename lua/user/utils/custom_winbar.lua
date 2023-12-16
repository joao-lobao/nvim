-- other possible color combinations on winbar with white, light_purple, dark_purple
local dark_gray = "#282a36"
local light_purple = "#bd93f9"
local dark_purple = "#6272a4"
local cyan = "#8be9fd"
local green = "#50fa7b"
local orange = "#ffb86c"
local pink = "#ff79c6"
local red = "#ff5555"
local bright_orange = "#fe8019"
local white = "#ffffff"
vim.api.nvim_set_hl(0, "StatusTypeLight", { bg = dark_gray, fg = "#aaaaaa" })
vim.api.nvim_set_hl(0, "StatusFileLight", { bg = dark_purple, fg = white })

Buffers = function()
	local buffers = vim.fn.getbufinfo({ buflisted = 1 })
	local current_buffer_path = vim.fn.expand("%:p")
	local buffer_names = {}
	for _, buffer in ipairs(buffers) do
		local buffer_path = buffer.name
		local buffer_name = vim.fn.fnamemodify(buffer_path, ":t")
		-- buffer name is different from empty string
		if buffer_name == "" then
			buffer_name = "[No Name]"
		end
		local is_modified = buffer.changed == 1 and " + " or " "

		-- buffer name is current buffer
		if buffer_path == current_buffer_path then
			table.insert(buffer_names, "%#StatusFileLight# 󰉺" .. " %t" .. "%M " .. "%#StatusTypeLight#")
		else
			table.insert(buffer_names, " " .. buffer_name .. is_modified)
		end
	end
	return "%#StatusTypeLight#" .. table.concat(buffer_names, " ")
end

Session = function()
	local session = vim.fn.fnamemodify(vim.v.this_session, ":t")
	if session ~= "" then
		session = " " .. session
	end
	return "%#StatusType#" .. session
end

Cwd = function()
	local current_cwd = " " .. vim.fn.getcwd()
	return "%#StatusFile#" .. current_cwd
end

Git_message = function()
	local file_dir = vim.fn.expand("%:p:h")
	local is_file_in_git_project = vim.fn.system("git -C " .. file_dir .. " rev-parse --is-inside-work-tree")
		== "true\n"
	local git_info = " No git repo "
	if is_file_in_git_project then
		git_info = " " .. vim.fn.system("git -C " .. file_dir .. " show -s --format=%s")
		git_info = string.gsub(git_info, "\n", "")
	end
	return "%#StatusNorm#" .. git_info
end

vim.o.showtabline = 2
-- on BufEnter update winbar
local group = vim.api.nvim_create_augroup("CustomWinBar", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	callback = function()
		vim.cmd("lua vim.o.winbar = Buffers()")
		vim.cmd("lua vim.o.tabline = ' ' .. Session() .. ' ' .. Cwd() .. ' %=' .. Git_message() .. ' '")
	end,
	group = group,
})
