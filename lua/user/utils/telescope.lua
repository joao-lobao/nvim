local actions = require("telescope.actions")
local M = require("telescope.builtin")
local action_state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")

-- function to create a list of commands
-- input format eg:
-- local input = {
-- 	{ description = "description1", value = "command1" },
-- 	{ description = "description2", value = "command2" },
-- 	{ description = "description3", value = "command3" },
-- }

function M.tasks(input)
	local enter = function(prompt_bufnr)
		local selected = action_state.get_selected_entry()
		actions.close(prompt_bufnr)
		vim.cmd(selected.value)
	end

	local opts = {
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
		sorter = sorters.get_generic_fuzzy_sorter({}),
		attach_mappings = function(_, map)
			map("i", "<CR>", enter)
			map("n", "<CR>", enter)
			return true
		end,
	}
	return pickers.new(opts):find()
end
