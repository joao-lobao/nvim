local actions = require("telescope.actions")
local M = require("telescope.builtin")
local action_state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")

-- function to create a list of commands
-- input format eg:
local common_actions = {
	{ description = "e  Empty buffer", value = "enew" },
	{ description = "q  Quit", value = "q" },
	{ description = "", value = "" },
	{ description = "🪙 Crypto Watcher", value = "SLoad Crypto Watcher" },
	{ description = "⁉️  Dotfiles", value = "SLoad Dotfiles" },
	{ description = "📡 Muxinator", value = "SLoad Muxinator" },
	{ description = "📓 Notes", value = "SLoad Notes" },
	{ description = "⚙️  VimConfig", value = "SLoad VimConfig" },
	{ description = "❌ Close Session", value = "SClose" },
	{ description = "", value = "" },
	{ description = "📊 ~/.config/nvim/init.lua", value = "e ~/.config/nvim/init.lua" },
	{ description = "📊 ~/.tmux.conf", value = "e ~/.tmux.conf" },
	{ description = "📊 ~/.zshrc", value = "e ~/.zshrc" },
	{ description = "", value = "" },
	{ description = "📁 Recent files", value = "Telescope oldfiles" },
	{ description = "🏡 Search home files", value = "Telescope search_files_in_home" },
	{ description = "", value = "" },
	{ description = " git push", value = "Git push" },
	{ description = " git push --force", value = "Git push --force" },
	{ description = " git log on buffer", value = "Gclog -- %" },
	{ description = "🔍 Search files ", value = "Telescope git_files" },
	{ description = "🔍 Search files", value = "Telescope find_files no_ignore=true hidden=true" },
	{ description = "🔍 Live grep ", value = "Telescope grep_git" },
	{ description = "🔍 Live grep", value = "Telescope grep_all" },
	{ description = "🅰  Keymaps", value = "Telescope keymaps" },
	{ description = "🗂 Buffers", value = "Telescope buffers" },
	{ description = "📌 Marks", value = "Telescope marks" },
	{ description = "🗃 Registers", value = "Telescope registers" },
	{ description = "🦆 Hatch Duck", value = "Hatch 🦆" },
	{ description = "🦆 Hatch Santa", value = "Hatch 🎅" },
	{ description = "🦆 Hatch Tree", value = "Hatch 🎄" },
	{ description = "🦆 Hatch Snowman", value = "Hatch ☃️ " },
	{ description = "☠️  HatchKill", value = "HatchKill" },
}

local task = function(input)
	local opts = {
		layout_config = { width = 0.3, height = 0.95 },
		finder = finders.new_table({
			results = input,
			entry_maker = function(entry)
				return {
					value = entry.value,
					display = entry.description,
					ordinal = entry.description,
				}
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

-- command to run on vim startup
-- vim.api.nvim_create_autocmd("VimEnter", {
-- 	callback = function()
-- 		task(common_actions)
-- 	end,
-- })
