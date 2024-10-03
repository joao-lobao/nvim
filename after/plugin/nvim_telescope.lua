local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
	defaults = {
		prompt_prefix = " 🔍 ",
		layout_config = { prompt_position = "top" },
		sorting_strategy = "ascending",
		mappings = {
			i = {
				["<C-q>"] = actions.close,
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

function M.grep_all()
	local grepOpts = {
		additional_args = function()
			return { "--no-ignore", "--hidden" }
		end,
		prompt_title = "Live grep on all files",
	}
	return M.live_grep(grepOpts)
end

function M.grep_in_cwd()
	local file_dir = vim.fn.expand("%:p:h")
	local is_git_repo = vim.fn.system("git -C " .. file_dir .. " rev-parse --is-inside-work-tree") == "true\n"
	local grepOpts = {
		file_ignore_patterns = { ".git/" },
		additional_args = function()
			return { "--hidden" }
		end,
		prompt_title = "Live grep on git files",
	}

	-- if git repo then grep in git files
	if is_git_repo then
		return M.live_grep(grepOpts)
	end

	-- else grep in project files
	grepOpts.file_ignore_patterns = { "node_modules" }
	grepOpts.prompt_title = "Live grep on project files"
	return M.live_grep(grepOpts)
end

-- find git files or files in cwd ignoring node_modules
-- use Telescope find_files to search in .git or node_modules
function M.find_in_cwd()
	local file_dir = vim.fn.expand("%:p:h")
	local is_git_repo = vim.fn.system("git -C " .. file_dir .. " rev-parse --is-inside-work-tree") == "true\n"
	if is_git_repo then
		return M.git_files()
	end
	local opts = {}
	opts.prompt_title = "Search files in cwd ignoring node_modules"
	opts.hidden = true
	opts.no_ignore = true
	opts.file_ignore_patterns = { "node_modules" }
	return M.find_files(opts)
end

local opts = { noremap = true, silent = true }

-- find git/project files in cwd
vim.api.nvim_set_keymap("n", "tf", "<Cmd>Telescope find_in_cwd<CR>", opts)
-- find all files in cwd
vim.api.nvim_set_keymap("n", "tF", "<Cmd>Telescope find_files no_ignore=true hidden=true<CR>", opts)
-- grep git/project in cwd
vim.api.nvim_set_keymap("n", "tg", "<Cmd>Telescope grep_in_cwd<CR>", opts)
-- grep all files in cwd
vim.api.nvim_set_keymap("n", "tG", "<Cmd>Telescope grep_all<CR>", opts)

-- find files from home dir as cwd
vim.api.nvim_set_keymap("n", "t~", "<Cmd>Telescope search_files_in_home<CR>", opts)
-- common or useful commands
vim.api.nvim_set_keymap("n", "tm", "<Cmd>Telescope common_actions<CR>", {})

vim.api.nvim_set_keymap("n", "ty", "<Cmd>Telescope registers<CR>", opts)
vim.api.nvim_set_keymap("n", "to", "<Cmd>Telescope oldfiles<CR>", opts)
vim.api.nvim_set_keymap("n", "tn", "<Cmd>Telescope buffers<CR>", opts)
vim.api.nvim_set_keymap("n", "tM", "<Cmd>Telescope marks<CR>", opts)
vim.api.nvim_set_keymap("n", "tk", "<Cmd>Telescope keymaps<CR>", opts)
