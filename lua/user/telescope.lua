local actions = require('telescope.actions')

require('telescope').setup {
  defaults = {
    prompt_prefix = " 🔍 ",
    layout_config = {prompt_position = "top"},
    sorting_strategy = "ascending",
    mappings = {
      n = {
        ["q"] = actions.close
      }
    }
  }
}

local M = require('telescope.builtin')
function M.search_files_in_home()
  local opts = {}
  opts.prompt_title= "Search files in home"
  opts.cwd = "~"
  opts.hidden = true
  opts.no_ignore = true
  M.find_files(opts)
end


-- find git files
vim.api.nvim_set_keymap('n', '<leader>gF', '<Cmd>Telescope git_files<CR>', { noremap = true, silent = true })
-- find all files (doesn't respect .gitignore)
vim.api.nvim_set_keymap('n', '<leader>F', '<Cmd>Telescope find_files no_ignore=true hidden=true<CR>', { noremap = true, silent = true })
-- grep respecting .gitignore
vim.api.nvim_set_keymap('n', '<leader>r', '<Cmd>Telescope live_grep<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>y', '<Cmd>Telescope registers<CR>', { noremap = true, silent = true })
-- grep not respecting .gitignore
vim.api.nvim_set_keymap('n', '<leader>R', ':lua require("telescope.builtin").live_grep({ additional_args = function(opts) return { "--no-ignore" } end })<CR>', { noremap = true, silent = true })
-- find files from home dir as cwd
vim.api.nvim_set_keymap('n', '<leader>~', '<Cmd>Telescope search_files_in_home<CR>', { noremap = true, silent = true })


vim.api.nvim_set_keymap('n', '<leader>B', '<Cmd>Telescope buffers<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>M', '<Cmd>Telescope marks<CR>', { noremap = true, silent = true })
-- find in current buffer
vim.api.nvim_set_keymap('n', '<leader>/', '<Cmd>Telescope current_buffer_fuzzy_find<CR>', { noremap = true, silent = true })

