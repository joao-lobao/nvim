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
  ia functon function
  ia functoin function
  ia funtoin function
  ia funtion function
  ia cosnt const
  ia conts const
  ia thsi this
  ia htis this
  ia tset test
  ia retrun return
  ia reutrn return
  ia retunr return
  ia retun return
  ia retur return
  ia nubmer number
  endfunction
  call AutoCorrect()
]])
