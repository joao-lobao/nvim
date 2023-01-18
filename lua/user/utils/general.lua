-- makes quickfix list close after list item selection (override the <CR>
-- mapping that is used in the quickfix window)
vim.cmd([[:autocmd FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>]])
vim.cmd([[:autocmd FileType qf nnoremap <buffer> <Esc> :cclose<CR>]])

--------------HELPER-------------
--- for vim yank highlight
vim.cmd([[
  augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 200})
  augroup END
]])

-------------HELPER-------------
-- Remember cursor position
vim.cmd([[ 
  augroup vimrc-remember-cursor-position
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal!    g`\"" | endif
  augroup END
]])

-------------HELPER-------------
-- Change highlight color for search hits and quickfix selection
vim.cmd([[
  autocmd ColorScheme gruvbox highlight QuickFixLine guifg=#444444 guibg=#a19f0c
  autocmd ColorScheme gruvbox highlight Search guibg=#444444 guifg=#a19f0c
]])

-------------HELPER-------------
-- get last commit message
vim.api.nvim_create_user_command("GitLastCommit", "!(git -C . log | sed -n '5p' | sed -e 's/^[ \t]*//')", {})

-------------HELPER-------------
-- autocorrect common mistakes
vim.cmd([[ 
  let s:auto_correct_loaded=0

  function! AutoCorrect()
    if exists('s:autocorrect_loaded')
      return
    else
      let s:autocorrect_loaded='1'
    endif
  ia funciton function
  ia cosnt const
  ia conts const
  ia thsi this
  ia htis this
  ia tset test
  ia reutrn return
  ia retunr return
  ia retun return
  ia retur return
  ia nubmer number
  endfunction
  call AutoCorrect()
]])

-------------HELPER-------------
-- goto class and method definitions
local custom_goto = require("user.utils.custom_goto")
vim.api.nvim_create_user_command("GotoClass", function()
  -- typescript class
	custom_goto.get_current("class_declaration", "type_identifier", 1)
  -- javascript class
	custom_goto.get_current("class_declaration", "identifier", 1)
end, {})

vim.api.nvim_create_user_command("GotoFunction", function()
  -- typescript and javascript class method
	custom_goto.get_current("method_definition", "property_identifier", 0)
  -- typescript and javascript function
	custom_goto.get_current("function_declaration", "identifier", 1)
end, {})
