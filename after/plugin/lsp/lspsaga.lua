-- import lspsaga safely
local saga_status, saga = pcall(require, "lspsaga")
if not saga_status then
	return
end

-- saga.init_lsp_saga({
saga.setup({
	-- use enter to open file with finder
	finder = {
		keys = {
			edit = "<CR>",
			quit = "<Esc>",
		},
	},
	-- use enter to open file with definition preview
	definition = {
		edit = "<CR>",
		quit = "<Esc>",
	},
	-- show outline
	outline = {
		keys = {
			jump = "<CR>",
			quit = "<Esc>",
		},
	},
	lightbulb = {
		enable = false,
	},
	code_action = {
		keys = {
			quit = { "q", "<Esc>" },
		},
	},
	-- renaming
	rename = {
		quit = "<Esc>",
		in_select = false,
	},
})
