local hl_categories = {
	command = "TelescopeResultsVariable",
	workspace = "TelescopeResultsIdentifier",
	bookmark = "TelescopeResultsBookmark",
	search = "TelescopeResultsConstant",
	vcs = "TelescopeResultsFunction",
}

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
Icons = {
	folder = "📂",
	opened_session = "📖",
	closed_session = "📓",
	config = "⚙️ ",
	files = "🗃",
	keymap = "🅰 ",
	git = " ",
	santa = "🎅",
	tool = "🛠",
	toolbox = "🧰",
}
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
	{ icon = "e", description = "Empty buffer", value = "enew", category = hl_categories.command },
	{ icon = "q", description = "Quit", value = "q", category = hl_categories.command },
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
local config_files = {
	{ icon = Icons.config, description = "~/.tmux.conf", value = "e ~/.tmux.conf", category = hl_categories.bookmark },
	{ icon = Icons.config, description = "~/.zshrc", value = "e ~/.zshrc", category = hl_categories.bookmark },
}
local searches = {
	{ icon = Icons.toolbox, description = "Oldfiles", value = "Telescope oldfiles", category = hl_categories.search },
}
local git_cmds = {
	{ icon = Icons.git, description = "git push --force", value = "Git push --force", category = hl_categories.vcs },
	{ icon = Icons.git, description = "git log %", value = "Gclog -- %", category = hl_categories.vcs },
	{ icon = Icons.git, description = "git log last commit", value = "GitLastCommit", category = hl_categories.vcs },
}

Common_actions = {}
local groups = { vim_cmds, sessions_actions(), config_files, searches, git_cmds }
table.foreach(groups, function(_, group)
	table.foreach(group, function(_, item)
		table.insert(Common_actions, item)
	end)
end)

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

Telescope_actions = {
	{
		icon = Icons.git,
		description = "Find Files",
		value = "Telescope find_in_cwd",
		category = hl_categories.command,
	},
	{
		icon = Icons.git,
		description = "Grep Files",
		value = "Telescope grep_in_cwd",
		category = hl_categories.command,
	},
	{
		icon = Icons.files,
		description = "Find All Files",
		value = "Telescope find_files no_ignore=true hidden=true",
		category = hl_categories.workspace,
	},
	{
		icon = Icons.files,
		description = "Grep All Files",
		value = "Telescope grep_all",
		category = hl_categories.workspace,
	},
	{
		icon = Icons.folder,
		description = "Find In Home",
		value = "Telescope search_files_in_home",
		category = hl_categories.bookmark,
	},
	{ icon = Icons.toolbox, description = "Buffers", value = "Telescope buffers", category = hl_categories.search },
	{ icon = Icons.toolbox, description = "Keymaps", value = "Telescope keymaps", category = hl_categories.search },
	{ icon = Icons.toolbox, description = "Marks", value = "Telescope marks", category = hl_categories.search },
	{ icon = Icons.toolbox, description = "Oldfiles", value = "Telescope oldfiles", category = hl_categories.search },
	{
		icon = Icons.toolbox,
		description = "Registers",
		value = "Telescope registers",
		category = hl_categories.search,
	},
	{ icon = Icons.files, description = "ObsidianSearch", value = "ObsidianSearch", category = hl_categories.vcs },
	{ icon = Icons.files, description = "ObsidianNew", value = "ObsidianNew", category = hl_categories.vcs },
}
