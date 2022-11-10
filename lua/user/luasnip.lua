vim.cmd[[
imap <silent><expr> <C-j> '<Plug>luasnip-jump-next'
" -1 for jumping backwards.
inoremap <silent> <C-k> <cmd>lua require'luasnip'.jump(-1)<Cr>

snoremap <silent> <C-j> <cmd>lua require('luasnip').jump(1)<Cr>
snoremap <silent> <C-k> <cmd>lua require('luasnip').jump(-1)<Cr>
]]
