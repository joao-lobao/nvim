local actions = require("telescope.actions")
local M = require("telescope.builtin")
local action_state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local entry_display = require("telescope.pickers.entry_display")
local icons = require("user/utils/constants").icons
local common_actions = require("user/utils/constants").common_actions

local displayer = entry_display.create({
	separator = " ",
	items = {
		{ remaining = true },
		{ remaining = true },
		{ remaining = true },
	},
})

local make_display = function(entry)
	local session = vim.fn.fnamemodify(vim.v.this_session, ":t")
	-- if session is not empty add the opened session icon
	if session ~= "" and string.match(entry.description, session) then
		entry.icon = icons.opened_session
		entry.description = session
		entry.value = ""
	end
	return displayer({
		{ entry.icon, entry.category },
		{ entry.description, entry.category },
		{ entry.value, "TelescopeResultsComment" },
	})
end

local task = function()
	local session = vim.fn.fnamemodify(vim.v.this_session, ":t")
	local prompt_title = icons.opened_session .. " " .. session
	-- if session is empty add the closed session icon
	if session == "" then
		prompt_title = icons.closed_session .. " Connect to Workspace"
	end
	local opts = {
		prompt_title = prompt_title,
		results_title = icons.folder .. " " .. vim.fn.getcwd(),
		layout_config = { anchor = "E", width = 0.5, height = 0.97 },
		finder = finders.new_table({
			results = common_actions,
			entry_maker = function(entry)
				local new_entry = {
					value = entry.value,
					icon = entry.icon,
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
	task()
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

vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = "red" })
vim.api.nvim_set_hl(0, "TelescopeResultsBookmark", { fg = "#de5d5d" })
vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = "#e993ed" })
vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = "orange" })
vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = "#de5d5d" })
