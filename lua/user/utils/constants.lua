local hl_categories = {
	command = "TelescopeResultsVariable",
	workspace = "TelescopeResultsIdentifier",
	bookmark = "TelescopeResultsBookmark",
	search = "TelescopeResultsConstant",
	vcs = "TelescopeResultsFunction",
}

local icons = {
	folder = "📂",
	opened_session = "📖",
	closed_session = "📓",
	config = "⚙️ ",
	close = "📕",
	files = "🗃",
	keymap = "🅰 ",
	git = "",
  santa = "🎅",
}

-- TODO: create a better way of adding picker options 2022-11-18
-- TODO: create a better way of adding horizontal separators between options 2022-11-19
local common_actions = {
	{ icon = "e", description = "Empty buffer", value = "enew", category = hl_categories.command },
	{ icon = "q", description = "Quit", value = "q", category = hl_categories.command },
	{ icon = "", description = "", value = "" },
	{
		icon = icons.santa,
		description = "AdventOfCode",
		value = "SLoad AdventOfCode",
		category = hl_categories.workspace,
	},
	{
		icon = icons.closed_session,
		description = "CryptoWatcher",
		value = "SLoad CryptoWatcher",
		category = hl_categories.workspace,
	},
	{
		icon = icons.closed_session,
		description = "Dotfiles",
		value = "SLoad Dotfiles",
		category = hl_categories.workspace,
	},
	{
		icon = icons.closed_session,
		description = "JoaoLobao",
		value = "SLoad JoaoLobao",
		category = hl_categories.workspace,
	},
	{
		icon = icons.closed_session,
		description = "Muxinator",
		value = "SLoad Muxinator",
		category = hl_categories.workspace,
	},
	{
		icon = icons.closed_session,
		description = "Notes",
		value = "SLoad Notes",
		category = hl_categories.workspace,
	},
	{
		icon = icons.closed_session,
		description = "Scripts",
		value = "SLoad Scripts",
		category = hl_categories.workspace,
	},
	{
		icon = icons.closed_session,
		description = "VimConfig",
		value = "SLoad VimConfig",
		category = hl_categories.workspace,
	},
	{ icon = icons.close, description = "Close Session", value = "SClose", category = hl_categories.workspace },
	{ icon = "", description = "", value = "" },
	{
		icon = icons.config,
		description = "~/Documents/list.md",
		value = "e ~/Documents/list.md",
		category = hl_categories.bookmark,
	},
	{
		icon = icons.config,
		description = "~/.tmux.conf",
		value = "e ~/.tmux.conf",
		category = hl_categories.bookmark,
	},
	{
		icon = icons.config,
		description = "~/.zshrc",
		value = "e ~/.zshrc",
		category = hl_categories.bookmark,
	},
	{ icon = "", description = "", value = "" },
	{
		icon = icons.files,
		description = "Old files",
		value = "Telescope oldfiles",
		category = hl_categories.search,
	},
	{
		icon = icons.keymap,
		description = "Keymaps",
		value = "Telescope keymaps",
		category = hl_categories.search,
	},
	{ icon = "", description = "", value = "" },
	{ icon = icons.git, description = "git push", value = "Git push", category = hl_categories.vcs },
	{
		icon = icons.git,
		description = "git push --force",
		value = "Git push --force",
		category = hl_categories.vcs,
	},
	{ icon = icons.git, description = "git log %", value = "Gclog -- %", category = hl_categories.vcs },
	{
		icon = icons.git,
		description = "git log last commit",
		value = "GitLastCommit",
		category = hl_categories.vcs,
	},
}

return { icons = icons, common_actions = common_actions }
