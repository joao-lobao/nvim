local actions = require("telescope.actions")
local M = require("telescope.builtin")
local action_state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")

-- TODO: create a better way of adding picker options 2022-11-18
-- function to create a list of commands
local common_actions = {
	{ description = "e  Empty buffer", value = "enew", ordinal = "e empty new buffer" },
	{ description = "q  Quit", value = "q", ordinal = "q quit" },
	{ description = "", value = "", ordinal = "" },
	{ description = "🚀 Crypto Watcher", value = "SLoad Crypto Watcher", ordinal = "c crypto watcher" },
	{ description = "🚀 Dotfiles", value = "SLoad Dotfiles", ordinal = "d dotfiles" },
	{ description = "🚀 JoaoLobao", value = "SLoad JoaoLobao", ordinal = "j joao lobao" },
	{ description = "🚀 Muxinator", value = "SLoad Muxinator", ordinal = "m muxinator" },
	{ description = "🚀 Notes", value = "SLoad Notes", ordinal = "n notes" },
	{ description = "🚀 VimConfig", value = "SLoad VimConfig", ordinal = "v vim config" },
	{ description = "❌ Close Session", value = "SClose", ordinal = "x sclose" },
	{ description = "", value = "", ordinal = "" },
	{ description = "📊 ~/.config/nvim/init.lua", value = "e ~/.config/nvim/init.lua", ordinal = "init.lua" },
	{ description = "📊 ~/.tmux.conf", value = "e ~/.tmux.conf", ordinal = ".tmux.conf" },
	{ description = "📊 ~/.zshrc", value = "e ~/.zshrc", ordinal = ".zshrc" },
	{ description = "", value = "", ordinal = "" },
	{ description = "📁 Old files", value = "Telescope oldfiles", ordinal = "old files" },
	{ description = "", value = "", ordinal = "" },
	{ description = " git push", value = "Git push" },
	{ description = " git push --force", value = "Git push --force" },
	{ description = " git log %", value = "Gclog -- %", ordinal = "git log buffer gclog -- %" },
	{ description = " git log last commit", value = "GitLastCommit" },
	{ description = "🅰  Keymaps", value = "Telescope keymaps", ordinal = "key maps" },
}

local task = function(input)
	local opts = {
		prompt_prefix = " 📡 ",
		prompt_title = "👷 " .. vim.fn.fnamemodify(vim.v.this_session, ":t"),
		results_title = "🗃 " .. vim.fn.getcwd(),
		selection_caret = "➡ ",
		finder = finders.new_table({
			results = input,
			entry_maker = function(entry)
				local session = vim.fn.fnamemodify(vim.v.this_session, ":t")
				local new_entry = {
					value = entry.value,
					display = entry.description,
					ordinal = entry.ordinal or entry.description,
				}
				-- show current session with different emoji icon
				if string.match(entry.description, session) then
					new_entry.display = "👷 " .. session
					new_entry.value = ""
				end
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
