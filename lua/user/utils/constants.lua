local hl_categories = {
	command = "TelescopeResultsVariable",
	workspace = "TelescopeResultsIdentifier",
	bookmark = "TelescopeResultsBookmark",
	search = "TelescopeResultsConstant",
	vcs = "TelescopeResultsFunction",
}

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
}
function Get_sessions_names()
	local sessions = vim.fn.glob(Session_dir .. "*", true, true)
	local sessions_names = {}
	for _, session in ipairs(sessions) do
		table.insert(sessions_names, vim.fn.fnamemodify(session, ":t"))
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
	{ icon = Icons.files, description = "Old files", value = "Telescope oldfiles", category = hl_categories.search },
	{ icon = Icons.keymap, description = "Keymaps", value = "Telescope keymaps", category = hl_categories.search },
}
local git_cmds = {
	{ icon = Icons.git, description = "git push", value = "Git push", category = hl_categories.vcs },
	{ icon = Icons.git, description = "git push --force", value = "Git push --force", category = hl_categories.vcs },
	{ icon = Icons.git, description = "git log %", value = "Gclog -- %", category = hl_categories.vcs },
	{ icon = Icons.git, description = "git log last commit", value = "GitLastCommit", category = hl_categories.vcs },
}

Common_actions = {}
local add_to_common_actions = function(group)
	for _, item in ipairs(group) do
		table.insert(Common_actions, item)
	end
end
add_to_common_actions(vim_cmds)
add_to_common_actions(sessions_actions())
add_to_common_actions(config_files)
add_to_common_actions(searches)
add_to_common_actions(git_cmds)
