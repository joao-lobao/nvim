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
	opts.file_ignore_patterns = { ".git/", "node_modules" }
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

-- CopilotChat actions
vim.api.nvim_set_keymap("n", "<leader>a", "<Cmd>Telescope CopilotChat<CR>", opts)
-- Telescope find actions
vim.api.nvim_set_keymap("n", "<leader>r", "<Cmd>Telescope Find<CR>", opts)
-- common or useful commands
vim.api.nvim_set_keymap("n", "<leader>n", "<Cmd>Telescope common_actions<CR>", {})
