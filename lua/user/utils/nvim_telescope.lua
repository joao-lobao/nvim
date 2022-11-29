local actions = require("telescope.actions")
local M = require("telescope.builtin")
local action_state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local entry_display = require("telescope.pickers.entry_display")
local hl_categories = {
	command = "TelescopeResultsVariable",
	workspace = "TelescopeResultsIdentifier",
	bookmark = "TelescopeResultsBookmark",
	search = "TelescopeResultsConstant",
	vcs = "TelescopeResultsFunction",
}
-- TODO: create a better way of adding picker options 2022-11-18
-- TODO: create a better way of adding horizontal separators between options 2022-11-19
-- function to create a list of commands
local common_actions = {
	{ description = "e  Empty buffer", value = "enew", category = hl_categories.command },
	{ description = "q  Quit", value = "q", category = hl_categories.command },
	{ description = "", value = "" },
	{ description = "🚀 Crypto Watcher", value = "SLoad Crypto Watcher", category = hl_categories.workspace },
	{ description = "🚀 Dotfiles", value = "SLoad Dotfiles", category = hl_categories.workspace },
	{ description = "🚀 JoaoLobao", value = "SLoad JoaoLobao", category = hl_categories.workspace },
	{ description = "🚀 Muxinator", value = "SLoad Muxinator", category = hl_categories.workspace },
	{ description = "🚀 Notes", value = "SLoad Notes", category = hl_categories.workspace },
	{ description = "🚀 VimConfig", value = "SLoad VimConfig", category = hl_categories.workspace },
	{ description = "❌ Close Session", value = "SClose", category = hl_categories.workspace },
	{ description = "", value = "" },
	{
		description = "📊 ~/.config/nvim/init.lua",
		value = "e ~/.config/nvim/init.lua",
		category = hl_categories.bookmark,
	},
	{ description = "📊 ~/.tmux.conf", value = "e ~/.tmux.conf", category = hl_categories.bookmark },
	{ description = "📊 ~/.zshrc", value = "e ~/.zshrc", category = hl_categories.bookmark },
	{ description = "", value = "" },
	{ description = "📁 Old files", value = "Telescope oldfiles", category = hl_categories.search },
	{ description = "🅰  Keymaps", value = "Telescope keymaps", category = hl_categories.search },
	{ description = "", value = "" },
	{ description = " git push", value = "Git push", category = hl_categories.vcs },
	{ description = " git push --force", value = "Git push --force", category = hl_categories.vcs },
	{ description = " git log %", value = "Gclog -- %", category = hl_categories.vcs },
	{ description = " git log last commit", value = "GitLastCommit", category = hl_categories.vcs },
}

local displayer = entry_display.create({
	separator = " ",
	items = {
		{ remaining = true },
		{ remaining = true },
	},
})

local make_display = function(entry)
	local session = vim.fn.fnamemodify(vim.v.this_session, ":t")
	if string.match(entry.description, session) then
		entry.description = "👷 " .. session
		entry.value = ""
	end
	return displayer({
		{ entry.description, entry.category },
		{ entry.value, "TelescopeResultsComment" },
	})
end

local placeholder = function()
	local virt_texts = {
		" 📡➡  connecting   👽",
		" 📡 ➡ connecting   👽",
		" 📡  ➡connecting   👽",
		" 📡   connecting➡  👽",
		" 📡   connecting ➡ 👽",
		" 📡   connecting  ➡👽",
	}
	local timer = vim.loop.new_timer()
	local position = 1
	local total_positions = 6
	local current_cycle = 0
	local iterations = 2
	timer:start(
		0,
		100,
		vim.schedule_wrap(function()
			vim.api.nvim_buf_clear_namespace(0, 1, 0, 1)
			if current_cycle == iterations then
				timer:close()
			else
				vim.api.nvim_buf_set_extmark(0, 1, 0, 0, {
					virt_text = {
						{ virt_texts[position], "Comment" },
					},
				})
			end
			if position == total_positions then
				position = 1
				current_cycle = current_cycle + 1
			else
				position = position + 1
			end
		end)
	)
end

local task = function(input)
	local opts = {
		prompt_prefix = " 🔭 ",
		prompt_title = "👷 " .. vim.fn.fnamemodify(vim.v.this_session, ":t"),
		results_title = "🗃 " .. vim.fn.getcwd(),
		layout_config = { anchor = "E", width = 0.5, height = 0.97 },
		finder = finders.new_table({
			results = input,
			entry_maker = function(entry)
				local new_entry = {
					value = entry.value,
					category = entry.category,
					description = entry.description,
					display = make_display,
					ordinal = entry.description,
				}
				return new_entry
			end,
		}),
		sorter = sorters.get_fzy_sorter({}),
		attach_mappings = function(prompt_bufnr)
			placeholder()
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				vim.cmd(selection.value)
			end)
			return true
		end,
	}
	return pickers.new(opts):find()
end

M.common_actions = function()
	task(common_actions)
end

-- a (bad) workaround for the Telescope issue folds only exist after Folds only
-- exist after using zx (E490: No fold found) when using "telescope" fzf plugin
vim.api.nvim_create_autocmd("BufRead", {
	callback = function()
		vim.api.nvim_create_autocmd("BufWinEnter", {
			once = true,
			command = "normal! zx",
		})
	end,
})

-- Change highlight color for telescope matching search hits
-- TODO: 2022-11-25 better way to implement hl color groups as below:
-- vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = "red", bg = "white" })
vim.cmd([[
  autocmd ColorScheme gruvbox highlight TelescopeMatching guifg=red
  autocmd ColorScheme gruvbox highlight TelescopeResultsBookmark guifg=#de5d5d
  autocmd ColorScheme gruvbox highlight TelescopePromptBorder guifg=#e993ed
  autocmd ColorScheme gruvbox highlight TelescopeResultsBorder guifg=orange
  autocmd ColorScheme gruvbox highlight TelescopePreviewBorder guifg=#de5d5d
]])
