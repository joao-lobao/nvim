local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
	defaults = {
		prompt_prefix = " 🔍 ",
		layout_config = { prompt_position = "top" },
		sorting_strategy = "ascending",
		mappings = {
			i = {
				["<Esc>"] = actions.close,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
			},
			n = {
				["q"] = actions.close,
			},
		},
	},
})

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

function M.grep_git()
	local grepOpts = {
		file_ignore_patterns = { ".git/" },
		additional_args = function()
			return { "--hidden" }
		end,
		prompt_title = "Live grep on git files",
	}
	M.live_grep(grepOpts)
end

function M.grep_all()
	local grepOpts = {
		file_ignore_patterns = { ".git/" },
		additional_args = function()
			return { "--no-ignore", "--hidden" }
		end,
		prompt_title = "Live grep on all files",
	}
	M.live_grep(grepOpts)
end

local opts = { noremap = true, silent = true }

-- find git files
vim.api.nvim_set_keymap("n", "<leader>gf", "<Cmd>Telescope git_files<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader><leader>", "<Cmd>Telescope git_files<CR>", opts)
-- find all files (doesn't respect .gitignore)
vim.api.nvim_set_keymap("n", "<leader>F", "<Cmd>Telescope find_files no_ignore=true hidden=true<CR>", opts)
-- grep respecting .gitignore
vim.api.nvim_set_keymap("n", "<leader>r", "<Cmd>Telescope grep_git<CR>", opts)
-- grep not respecting .gitignore
vim.api.nvim_set_keymap("n", "<leader>R", "<Cmd>Telescope grep_all<CR>", opts)
-- find files from home dir as cwd
vim.api.nvim_set_keymap("n", "<leader>~", "<Cmd>Telescope search_files_in_home<CR>", opts)
-- common or useful commands
vim.api.nvim_set_keymap("n", "<leader>m", "<Cmd>Telescope common_actions<CR>", {})

vim.api.nvim_set_keymap("n", "<leader>y", "<Cmd>Telescope registers<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>o", "<Cmd>Telescope oldfiles<CR>", opts)
-- vim.api.nvim_set_keymap("n", "<leader>B", "<Cmd>Telescope buffers<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>n", "<Cmd>Telescope buffers<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>M", "<Cmd>Telescope marks<CR>", opts)
-- find in current buffer
vim.api.nvim_set_keymap("n", "<leader>/", "<Cmd>Telescope current_buffer_fuzzy_find<CR>", opts)
