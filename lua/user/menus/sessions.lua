vim.api.nvim_set_keymap('n', 'sm', ':popup Sessions<CR>', { noremap = true })

vim.cmd[[
  nmenu Sessions.\ Crypto\ Watcher :SLoad Crypto Watcher<CR>
  nmenu Sessions.\ Dotfiles :SLoad Dotfiles<CR>
  nmenu Sessions.\ Muxinator :SLoad Muxinator<CR>
  nmenu Sessions.\ Notes :SLoad Notes<CR>
  nmenu Sessions.\ VimConfig :SLoad VimConfig<CR>
  nmenu Sessions.\ SClose :SClose<CR>
]]
