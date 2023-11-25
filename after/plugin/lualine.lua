local custom_fname = require("lualine.components.filename"):extend()

function custom_fname:update_status()
	local session = vim.fn.fnamemodify(vim.v.this_session, ":t")
  if session == "" then
    return "No Session"
  end
	return "Session: " .. session
end

require("lualine").setup({
	options = {
		-- theme = "gruvbox",
		theme = "material",
	},
	tabline = {
		lualine_a = {
			{
				"buffers",
				show_filename_only = false, -- Shows shortened relative path when set to false.
				show_modified_status = true, -- Shows indicator when the buffer is modified.
			},
		},
		lualine_z = { custom_fname },
	},
})
