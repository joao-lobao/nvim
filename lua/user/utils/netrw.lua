-- netrw config
vim.g.netrw_banner = 0
vim.g.netrw_localcopydircmd = "cp -r" -- to enable copy directories recursively
vim.g.netrw_keepdir = 0 -- fixes the netrw bug move back again files already moved
-- vim.g.netrw_liststyle = 3 -- show tree style

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<leader>e", ":Ex<CR>", opts)

-- netrw specific remappings
vim.cmd([[
  function! NetrwMapping()
  endfunction

  augroup netrw_mapping
    autocmd!
    autocmd filetype netrw call NetrwMapping()
  augroup END

  function! NetrwMapping()
    nmap <buffer> h -^
    nmap <buffer> l <CR>
    nmap <buffer> gq :Rex<CR>
  endfunction
]])
