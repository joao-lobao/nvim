require('refactoring').setup({})

local telescope = require("telescope")
-- load refactoring Telescope extension
telescope.load_extension("refactoring")

local opts = { noremap = true, silent = true }
-- remap to open the Telescope refactoring menu in visual mode
vim.api.nvim_set_keymap(
	"v",
	"<leader>rr",
	"<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
	opts
)
