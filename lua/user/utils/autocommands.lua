local opts = { noremap = true, silent = true }
--- makes quickfix list close after list item selection (override the <CR>
--- mapping that is used in the quickfix window)
local group_quickfix = vim.api.nvim_create_augroup("CustomQFLMapping", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	pattern = "qf",
	callback = function()
		vim.api.nvim_buf_set_keymap(0, "n", "<CR>", "<CR>:cclose<CR>", opts)
		vim.api.nvim_buf_set_keymap(0, "n", "<Esc>", ":cclose<CR>", opts)
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

-- netrw
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1
-- statusline and winbar
local dark_gray = "#282a36"
local green = "#50fa7b"
local red = "#ff5555"
local light_purple = "#bd93f9"
local bright_orange = "#fe8019"
vim.api.nvim_set_hl(0, "MsgArea", { bg = dark_gray, fg = green })
vim.api.nvim_set_hl(0, "ErrorMsg", { bg = dark_gray, fg = red })
vim.api.nvim_set_hl(0, "WinSeparator", { bg = dark_gray, fg = bright_orange })
vim.api.nvim_set_hl(0, "StatusLine", { bg = dark_gray, fg = bright_orange })
vim.api.nvim_set_hl(0, "WinBar", { bg = dark_gray, fg = light_purple })
-- winbar
vim.o.winbar = "%= %y %F %m%="

--TODO: features removed
--custom_git
  --git signs
  --hunk stage/reset
  --hunk navigation
--custom fugitive
  --git signs
  --hunk navigation
--custom_null_ls
  --js/ts utils custom diagnostic
  --eslint custom conditional rules depending on eslint rules present or not 
--custom_goto
  --replaced by treesitter textobjects
--custom_winbar
--custom_statusline
--custom_netrw
--constants
  --colors
