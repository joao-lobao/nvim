lua <<EOF
local actions = require('telescope.actions')

require('telescope').setup {
  defaults = {
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

nnoremap <silent> <leader>gF <Cmd>Telescope git_files<CR>
nnoremap <silent> <leader>F <Cmd>Telescope find_files<CR>
nnoremap <silent> <leader>R <Cmd>Telescope live_grep<CR>
nnoremap <silent> <leader>B <Cmd>Telescope buffers<CR>
nnoremap <silent> <leader>M <Cmd>Telescope marks<CR>
nnoremap <silent> <leader>T <Cmd>Telescope tags<CR>
" find in current buffer
nnoremap <silent> <leader>/ <Cmd>Telescope current_buffer_fuzzy_find<CR>

