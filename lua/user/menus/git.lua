vim.api.nvim_set_keymap('n', 'gm', ':popup GitActions<CR>', { noremap = true })

vim.cmd[[
  nmenu GitActions.\ Git\ push :Git push<CR>
  nmenu GitActions.\ Git\ push\ --force :Git push --force<CR>
  nmenu GitActions.\ Gclog\ --\ % :Gclog -- %<CR><C-w>j
  nmenu GitActions.\ Amend :Git commit --amend --no-edit<CR>
  nmenu GitActions.\ Amend\ and\ reword :Git commit --amend -m ""<Left>
]]
