lua <<EOF
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

EOF

" find git files
nnoremap <silent> <leader>gF <Cmd>Telescope git_files<CR>
" find all files (doesn't respect .gitignore)
nnoremap <silent> <leader>F <Cmd>Telescope find_files no_ignore=true<CR>
" grep respecting .gitignore
nnoremap <silent> <leader>r <Cmd>Telescope live_grep<CR>
" grep not respecting .gitignore
nnoremap <silent> <leader>R :lua require('telescope.builtin').live_grep({ additional_args = function(opts) return { "--no-ignore" } end })<CR>

nnoremap <silent> <leader>B <Cmd>Telescope buffers<CR>
nnoremap <silent> <leader>M <Cmd>Telescope marks<CR>
nnoremap <silent> <leader>T <Cmd>Telescope tags<CR>
" find in current buffer
nnoremap <silent> <leader>/ <Cmd>Telescope current_buffer_fuzzy_find<CR>

