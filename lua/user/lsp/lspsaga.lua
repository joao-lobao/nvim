-- import lspsaga safely
local saga_status, saga = pcall(require, "lspsaga")
if not saga_status then
	return
end

saga.init_lsp_saga({
	-- keybinds for navigation in lspsaga window
	move_in_saga = { prev = "<C-k>", next = "<C-j>" },
	-- use enter to open file with finder
	finder_action_keys = {
		open = "<CR>",
    quit = "<Esc>",
	},
	-- use enter to open file with definition preview
	definition_action_keys = {
		edit = "<CR>",
    quit = "<Esc>",
	},
	-- show outline
	show_outline = {
		jump_key = "<CR>",
	},
  code_action_keys = {
    quit = "<Esc>",
  },
})
