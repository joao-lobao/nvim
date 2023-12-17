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

-- telescope common_actions to run on vim startup
local group_telescope = vim.api.nvim_create_augroup("CustomTelescope", { clear = true })
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		-- if empty buffer
		if vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then
			require("telescope.builtin").common_actions()
		end
	end,
	group = group_telescope,
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

-- close and save sessions on vim leave
local group_session_manager = vim.api.nvim_create_augroup("CustomSessionManager", { clear = true })
vim.api.nvim_create_autocmd("VimLeave", {
	callback = function()
		SessionSave()
	end,
	group = group_session_manager,
})

-- create autocommands group so they can be cleared later
local group_git = vim.api.nvim_create_augroup("CustomGit", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
	pattern = { "*.js", "*.jsx", "*.json", "*.ts", "*.tsx", "*.lua", "*.css", "*.scss", "*.md" },
	callback = function()
		if IsBufferEligibleForSigning() then
			SetDiffSigns()
		end
	end,
	group = group_git,
})

-- on WinLeave remove winbar
local group_winbar = vim.api.nvim_create_augroup("CustomWinBar", { clear = true })
vim.api.nvim_create_autocmd("WinLeave", {
	callback = function()
		vim.cmd("lua vim.wo.winbar = ''")
	end,
	group = group_winbar,
})
-- on BufEnter, WinEnter update winbar
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
	callback = function()
		vim.cmd("lua vim.o.tabline = Buffers()")
		if vim.bo.filetype == "" then
			return
		end
		vim.cmd("lua vim.wo.winbar = '' .. Session() .. ' ' .. Cwd() .. ' %=' .. Git_message() .. ' '")
	end,
	group = group_winbar,
})

-- create autocommand to set keymaps on specific filetype
local group_netrw = vim.api.nvim_create_augroup("CustomNetrwMapping", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	pattern = "netrw",
	callback = function()
		vim.api.nvim_buf_set_keymap(0, "n", "l", ":e <cfile><CR>", opts)
		vim.api.nvim_buf_set_keymap(0, "n", "gq", ":Rex<CR>", opts)
	end,
	group = group_netrw,
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
