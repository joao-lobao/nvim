local opts = { noremap = true, silent = true }
--- makes quickfix list close after list item selection (override the <CR>
--- mapping that is used in the quickfix window)
local group_quickfix = vim.api.nvim_create_augroup("CustomQFLMapping", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	pattern = "qf",
	callback = function()
		vim.api.nvim_buf_set_keymap(0, "n", "<CR>", "<CR><cmd>lua Close_qf()<CR>", opts)
		vim.api.nvim_buf_set_keymap(0, "n", "<Esc>", "<cmd>lua Close_qf()<CR>", opts)
		vim.api.nvim_buf_set_keymap(0, "n", "f", "/", opts)
		for i = 1, 10, 1 do
			vim.api.nvim_buf_set_keymap(0, "n", tostring(i), tostring(i) .. "G<CR>:cclose<CR>", opts)
		end
		vim.o.relativenumber = false
	end,
	group = group_quickfix,
})

--- for vim yank highlight
local group_yank = vim.api.nvim_create_augroup("HighlightYank", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.cmd("lua require'vim.highlight'.on_yank({timeout = 200})")
	end,
	group = group_yank,
})

-- Remember cursor position
local group_cursor = vim.api.nvim_create_augroup("RememberCursor", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		vim.cmd([[ if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal!    g`\"" | endif ]])
	end,
	group = group_cursor,
})

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
