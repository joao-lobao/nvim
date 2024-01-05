Dark_gray = "#282a36"
Light_purple = "#bd93f9"
Dark_purple = "#6272a4"
Cyan = "#8be9fd"
Green = "#50fa7b"
Orange = "#ffb86c"
Pink = "#ff79c6"
Red = "#ff5555"
Bright_orange = "#fe8019"
Gray = "#bbbbbb"
White = "#ffffff"
Session_dir = "~/.config/nvim/session/"
function Get_sessions_names(pattern)
	local sessions = vim.fn.glob(Session_dir .. "*", true, true)
	local sessions_names = {}
	for _, session in ipairs(sessions) do
		if pattern == nil then
			table.insert(sessions_names, vim.fn.fnamemodify(session, ":t"))
		elseif vim.startswith(vim.fn.fnamemodify(session:lower(), ":t"), pattern:lower()) then
			table.insert(sessions_names, vim.fn.fnamemodify(session, ":t"))
		end
	end
	return sessions_names
end
