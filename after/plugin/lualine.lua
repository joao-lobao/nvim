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
	},
})
