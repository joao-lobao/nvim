vim.api.nvim_set_keymap('n', '<leader>S', ':Startify<CR>', { noremap = true })

vim.g.startify_session_dir = "~/.config/nvim/session"

vim.g.startify_lists = {
  { type= 'sessions',  header= { '   Sessions' }},
  { type= 'bookmarks', header= { '   Bookmarks' }},
  { type= 'files',     header= { '   Files' }}
}

vim.g.startify_bookmarks = {
  { i= "~/.config/nvim/init.lua" },
  { t= "~/.tmux.conf" },
  { z= "~/.zshrc" }
}

vim.g.startify_session_persistence = 1

vim.g.startify_custom_indices = { 'c', 'd', 'm', 'n', 'v' }

vim.g.startify_custom_header = {'   ⚡️ NVIM 🚀 with Lua 👽'}
