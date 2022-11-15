local actions = require("telescope.actions")
local M = require("telescope.builtin")
local action_state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")

-- function to create a list of commands
-- input format eg:
local common_actions = {
	{ description = "e  Empty buffer", value = "enew", ordinal="create new buffer" },
	{ description = "", value = "", ordinal=""  },
	{ description = "🚀 Crypto Watcher", value = "SLoad Crypto Watcher", ordinal="" },
	{ description = "🚀 Dotfiles", value = "SLoad Dotfiles", ordinal="" },
	{ description = "🚀 JoaoLobao", value = "SLoad JoaoLobao", ordinal="tmuxinator tmux joaolobao joao lobao .com" },
	{ description = "🚀 Muxinator", value = "SLoad Muxinator", ordinal="tmuxinator tmux" },
	{ description = "🚀 Notes", value = "SLoad Notes", ordinal="" },
	{ description = "🚀 VimConfig", value = "SLoad VimConfig", ordinal="vim config" },
	{ description = "", value = "", ordinal="" },
	{ description = "❌ Close Session", value = "SClose", ordinal="SClose" },
	{ description = "", value = "", ordinal="" },
	{ description = "📊 ~/.config/nvim/init.lua", value = "e ~/.config/nvim/init.lua", ordinal="init.lua" },
	{ description = "📊 ~/.tmux.conf", value = "e ~/.tmux.conf", ordinal="tmux.conf" },
	{ description = "📊 ~/.zshrc", value = "e ~/.zshrc", ordinal="zshrc" },
	{ description = "", value = "", ordinal="" },
	{ description = "📁 Recent files", value = "Telescope oldfiles", ordinal="old files oldfiles" },
	{ description = "", value = "", ordinal="" },
	{ description = " git push", value = "Git push", ordinal="" },
	{ description = " git push --force", value = "Git push --force", ordinal="force" },
	{ description = " git log on buffer", value = "Gclog -- %", ordinal="glog" },
	{ description = "🅰  Keymaps", value = "Telescope keymaps", ordinal="key maps" },
}

local task = function(input)
	local opts = {
		layout_config = { width = 0.3, },
		finder = finders.new_table({
			results = input,
			entry_maker = function(entry)
				return {
					value = entry.value,
					display = entry.description,
					ordinal = entry.description .. " " .. entry.ordinal,
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
