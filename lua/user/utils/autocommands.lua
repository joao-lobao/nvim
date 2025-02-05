local opts = { noremap = true, silent = true }
--- makes quickfix list close after list item selection (override the <CR>
--- mapping that is used in the quickfix window)
local group_quickfix = vim.api.nvim_create_augroup("CustomQFLMapping", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	pattern = "qf",
	callback = function()
		vim.api.nvim_buf_set_keymap(0, "n", "<C-j>", "<CR>:cnext<CR>:copen<CR>", opts)
		vim.api.nvim_buf_set_keymap(0, "n", "<C-k>", "<CR>:cprev<CR>:copen<CR>", opts)
		vim.api.nvim_buf_set_keymap(0, "n", "<CR>", "<CR>:cclose<CR>", opts)
		vim.api.nvim_buf_set_keymap(0, "n", "<Esc>", ":cclose<CR>", opts)
		vim.api.nvim_buf_set_keymap(0, "n", "q", ":cclose<CR>", opts)
		vim.api.nvim_buf_set_keymap(0, "n", "f", "/", {})
		for i = 1, 9, 1 do
			vim.api.nvim_buf_set_keymap(0, "n", tostring(i), tostring(i) .. "G<CR>:cclose<CR>", opts)
		end
		vim.o.relativenumber = false
	end,
	group = group_quickfix,
})

--- use q to close help windows
local group_help = vim.api.nvim_create_augroup("CustomHelpMapping", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	pattern = "help",
	callback = function()
		vim.api.nvim_buf_set_keymap(0, "n", "q", ":bd<CR>", opts)
		vim.api.nvim_buf_set_keymap(0, "n", "<Esc>", ":bd<CR>", opts)
	end,
	group = group_help,
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
  ia funciotn function
  ia funcitno function
  ia functon function
  ia functoin function
  ia funtoin function
  ia funtion function
  ia fucntion function
  ia funtcion function
  ia fnuction function
  ia Funciton Function
  ia Funciotn Function
  ia Funcitno Function
  ia Functon Function
  ia Functoin Function
  ia Funtoin Function
  ia Funtion Function
  ia Fucntion Function
  ia Funtcion Function
  ia Fnuction Function
  ia cosnt const
  ia csont const
  ia scont const
  ia conts const
  ia Cosnt Const
  ia Csont Const
  ia Conts Const
  ia thsi this
  ia htis this
  ia tset test
  ia tets test
  ia retrun return
  ia reutrn return
  ia retunr return
  ia retun return
  ia retur return
  ia nubmer number
  ia lcoal local
  ia lcola local
  ia lcocal local
  ia Thsi this
  ia Tset Test
  ia Tets Test
  ia Retrun Return
  ia Reutrn Return
  ia Retunr Return
  ia Retun Return
  ia Retur Return
  ia Nubmer Number
  ia Lcoal Local
  ia Lcola Local
  ia Lcocal Local
  endfunction
  call AutoCorrect()
]])
