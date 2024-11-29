local actions = require("telescope.actions")
local M = require("telescope.builtin")
local action_state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local entry_display = require("telescope.pickers.entry_display")

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
		entry.icon = Icons.opened_session
		entry.description = session
		entry.value = ""
	end
	return displayer({
		{ entry.icon, entry.category },
		{ entry.description, entry.category },
		{ entry.value, "TelescopeResultsComment" },
	})
end

local task = function(custom_actions)
	local session = vim.fn.fnamemodify(vim.v.this_session, ":t")
	local prompt_title = Icons.opened_session .. " " .. session
	-- if session is empty add the closed session icon
	if session == "" then
		prompt_title = Icons.closed_session .. " Connect to Workspace"
	end

	-- 32 is the number of actions needed to fill the height
	local max_num_of_actions = 32
	local num_of_common_actions = #custom_actions
	local win_height = num_of_common_actions / max_num_of_actions + 0.75 / num_of_common_actions
	if win_height > 0.99 then
		win_height = 0.99
	end

	local opts = {
		prompt_title = prompt_title,
		results_title = Icons.folder .. " " .. vim.fn.getcwd(),
		-- dynamic window height based on the number of actions
		layout_config = { anchor = "C", width = 0.3, height = win_height },
		finder = finders.new_table({
			results = custom_actions,
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
	task(Common_actions)
end

M.CopilotChat = function()
	task(Copilot_actions)
end

-- Change highlight color for telescope matching search hits
vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = "red" })
vim.api.nvim_set_hl(0, "TelescopeResultsBookmark", { fg = "#de5d5d" })
vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = "#e993ed" })
vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = "orange" })
vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = "#de5d5d" })

-- telescope common_actions to run on vim startup
local group_telescope = vim.api.nvim_create_augroup("CustomTelescope", { clear = true })
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		-- if empty buffer
		if vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then
			require("telescope.builtin").common_actions()
		end
	end,
	group = group_telescope,
})
