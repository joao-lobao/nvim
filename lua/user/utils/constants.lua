local hl_categories = {
	command = "TelescopeResultsVariable",
	workspace = "TelescopeResultsIdentifier",
	bookmark = "TelescopeResultsBookmark",
	search = "TelescopeResultsConstant",
	vcs = "TelescopeResultsFunction",
}

Dark_gray = "#282a36"
Medium_gray = "#3c3836"
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
Icons = {
	folder = "📂",
	opened_session = "📖",
	closed_session = "📓",
	config = "⚙️ ",
	files = "🗃",
	buffer = " ",
	keymap = "🅰 ",
	git = " ",
	santa = "🎅",
	tool = "🛠",
	toolbox = "🧰",
}
function Is_git_repo()
	local directory = vim.fn.expand("%:p:h")
	return vim.fn.system("git -C " .. directory .. " rev-parse --is-inside-work-tree") == "true\n"
end

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

-- put actions here
local vim_cmds = {
	{ icon = Icons.buffer, description = "Empty buffer", value = "enew", category = hl_categories.command },
}
local sessions_actions = function()
	local sessions = vim.fn.glob(Session_dir .. "*", true, true)
	local actions = {}
	for _, session in ipairs(sessions) do
		local session_name = vim.fn.fnamemodify(session, ":t")
		table.insert(actions, {
			icon = Icons.closed_session,
			description = session_name,
			value = "SLoad " .. session_name,
			category = hl_categories.workspace,
		})
	end
	return actions
end
local searches = {
	{
		icon = Icons.toolbox,
		description = "Find Home Files",
		value = "Telescope search_files_in_home",
		category = hl_categories.search,
	},
	{
		icon = Icons.toolbox,
		description = "Find Project Files",
		value = "Telescope find_in_cwd",
		category = hl_categories.search,
	},
	{ icon = Icons.toolbox, description = "Oldfiles", value = "Telescope oldfiles", category = hl_categories.search },
}

Common_actions = {}
local groups = { vim_cmds, sessions_actions(), searches }
for _, group in ipairs(groups) do
	for _, item in ipairs(group) do
		table.insert(Common_actions, item)
	end
end

Copilot_actions = {
	{
		icon = Icons.git,
		value = "CopilotChatCommit",
		description = "Commit",
		category = hl_categories.vcs,
	},
	{
		icon = Icons.keymap,
		value = "CopilotChat BetterNamings",
		description = "BetterNamings",
		category = hl_categories.command,
	},
	{
		icon = Icons.keymap,
		value = "CopilotChat Optimize",
		description = "Optimize",
		category = hl_categories.command,
	},
	{
		icon = Icons.keymap,
		value = "CopilotChat Refactor",
		description = "Refactor",
		category = hl_categories.command,
	},
	{
		icon = Icons.keymap,
		value = "CopilotChat Review",
		description = "Review",
		category = hl_categories.command,
	},
	{
		icon = Icons.opened_session,
		value = "CopilotChat Explain",
		description = "Explain",
		category = hl_categories.workspace,
	},
	{
		icon = Icons.config,
		value = "CopilotChat Docs",
		description = "Docs",
		category = hl_categories.bookmark,
	},
	{
		icon = Icons.config,
		value = "CopilotChat Fix",
		description = "Fix",
		category = hl_categories.bookmark,
	},
	{
		icon = Icons.config,
		value = "CopilotChat Tests",
		description = "Tests",
		category = hl_categories.bookmark,
	},
	{
		icon = Icons.tool,
		value = "AiAsk",
		description = "Ask",
		category = hl_categories.search,
	},
	{
		icon = Icons.tool,
		value = "CopilotChatToggle",
		description = "Toggle",
		category = hl_categories.search,
	},
	{
		icon = Icons.tool,
		value = "CopilotChatReset",
		description = "Reset",
		category = hl_categories.search,
	},
}
