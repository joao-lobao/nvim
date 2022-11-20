local actions = require("telescope.actions")
local M = require("telescope.builtin")
local action_state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local entry_display = require("telescope.pickers.entry_display")

-- TODO: create a better way of adding picker options 2022-11-18
-- TODO: create a better way of adding horizontal separators between options 2022-11-19
-- function to create a list of commands
local common_actions = {
	{ description = "e  Empty buffer", value = "enew" },
	{ description = "q  Quit", value = "q" },
	{ description = "", value = "" },
	{ description = "🚀 Crypto Watcher", value = "SLoad Crypto Watcher" },
	{ description = "🚀 Dotfiles", value = "SLoad Dotfiles" },
	{ description = "🚀 JoaoLobao", value = "SLoad JoaoLobao" },
	{ description = "🚀 Muxinator", value = "SLoad Muxinator" },
	{ description = "🚀 Notes", value = "SLoad Notes" },
	{ description = "🚀 VimConfig", value = "SLoad VimConfig" },
	{ description = "❌ Close Session", value = "SClose" },
	{ description = "", value = "" },
	{ description = "📊 ~/.config/nvim/init.lua", value = "e ~/.config/nvim/init.lua" },
	{ description = "📊 ~/.tmux.conf", value = "e ~/.tmux.conf" },
	{ description = "📊 ~/.zshrc", value = "e ~/.zshrc" },
	{ description = "", value = "" },
	{ description = "📁 Old files", value = "Telescope oldfiles" },
	{ description = "", value = "" },
	{ description = " git push", value = "Git push" },
	{ description = " git push --force", value = "Git push --force" },
	{ description = " git log %", value = "Gclog -- %" },
	{ description = " git log last commit", value = "GitLastCommit" },
	{ description = "🅰  Keymaps", value = "Telescope keymaps" },
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
		{ entry.description, "TelescopeResultsIdentifier" },
		{ entry.value, "TelescopeResultsComment" },
	})
end

local task = function(input)
	local opts = {
		prompt_prefix = " 📡 ",
		prompt_title = "👷 " .. vim.fn.fnamemodify(vim.v.this_session, ":t"),
		results_title = "🗃 " .. vim.fn.getcwd(),
		selection_caret = "➡ ",
		finder = finders.new_table({
			results = input,
			entry_maker = function(entry)
				local new_entry = {
					value = entry.value,
					description = entry.description,
					display = make_display,
					ordinal = entry.description,
				}
				return new_entry
			end,
		}),
		sorter = sorters.get_fzy_sorter({}),
		attach_mappings = function(prompt_bufnr)
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
vim.cmd([[
  autocmd ColorScheme gruvbox highlight TelescopeMatching guifg=#ba3636
]])
