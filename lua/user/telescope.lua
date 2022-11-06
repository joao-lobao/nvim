local actions = require("telescope.actions")
local telescope = require("telescope")

telescope.setup({
	defaults = {
		prompt_prefix = " 🔍 ",
		layout_config = { prompt_position = "top" },
		sorting_strategy = "ascending",
		mappings = {
			n = {
				["q"] = actions.close,
			},
		},
	},
})
-- load refactoring Telescope extension
telescope.load_extension("refactoring")

local M = require("telescope.builtin")
function M.search_files_in_home()
	local opts = {}
	opts.prompt_title = "Search files in home"
	opts.cwd = "~"
	opts.hidden = true
	opts.no_ignore = true
	opts.file_ignore_patterns = { ".git/" }
	M.find_files(opts)
end

local opts = { noremap = true, silent = true }

-- find git files
vim.api.nvim_set_keymap("n", "<leader>gF", "<Cmd>Telescope git_files<CR>", opts)
-- find all files (doesn't respect .gitignore)
vim.api.nvim_set_keymap("n", "<leader>F", "<Cmd>Telescope find_files no_ignore=true hidden=true<CR>", opts)
-- grep respecting .gitignore
vim.api.nvim_set_keymap(
	"n",
	"<leader>r",
	':lua require("telescope.builtin").live_grep({ additional_args = function(opts) return { "--hidden" } end, file_ignore_patterns = {".git/"} })<CR>',
	opts
)
vim.api.nvim_set_keymap("n", "<leader>y", "<Cmd>Telescope registers<CR>", opts)
-- grep not respecting .gitignore
vim.api.nvim_set_keymap(
	"n",
	"<leader>R",
	':lua require("telescope.builtin").live_grep({ additional_args = function(opts) return { "--no-ignore", "--hidden" } end, file_ignore_patterns = {".git/"}  })<CR>',
	opts
)
-- find files from home dir as cwd
vim.api.nvim_set_keymap("n", "<leader>~", "<Cmd>Telescope search_files_in_home<CR>", opts)

vim.api.nvim_set_keymap("n", "<leader>B", "<Cmd>Telescope buffers<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>M", "<Cmd>Telescope marks<CR>", opts)
-- find in current buffer
vim.api.nvim_set_keymap("n", "<leader>/", "<Cmd>Telescope current_buffer_fuzzy_find<CR>", opts)
