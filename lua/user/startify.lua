vim.api.nvim_set_keymap("n", "<leader>S", ":Startify<CR>", { noremap = true })

vim.g.startify_session_dir = "~/.config/nvim/session"

-- global function to replace vim-devicons for nvim-web-devicons
-- replace function
function _G.webDevIcons(path)
	local filename = vim.fn.fnamemodify(path, ":t")
	local extension = vim.fn.fnamemodify(path, ":e")
	return require("nvim-web-devicons").get_icon(filename, extension, { default = true })
end
-- function to be replaced
vim.cmd([[
  function! StartifyEntryFormat() abort
    return 'v:lua.webDevIcons(absolute_path) . " " . entry_path'
  endfunction

  " customize Startify text colors
  autocmd ColorScheme gruvbox highlight StartifyNumber  guifg=#85DACD
  autocmd ColorScheme gruvbox highlight StartifyBracket guifg=gray
  autocmd ColorScheme gruvbox highlight StartifySpecial guifg=#C4CCFF
  autocmd ColorScheme gruvbox highlight StartifySection guifg=#CB7080
  autocmd ColorScheme gruvbox highlight StartifyPath    guifg=orange
  autocmd ColorScheme gruvbox highlight StartifyFile    guifg=#97FF97
]])

vim.g.startify_lists = {
	{ type = "sessions", header = { "   Sessions" } },
	{ type = "bookmarks", header = { "   Bookmarks" } },
	{ type = "files", header = { "   Files" } },
}

vim.g.startify_bookmarks = {
	{ i = "~/.config/nvim/init.lua" },
	{ t = "~/.tmux.conf" },
	{ z = "~/.zshrc" },
}

vim.g.startify_session_persistence = 1

vim.g.startify_custom_indices = { "c", "d", "j", "m", "n", "v" }

vim.g.startify_custom_header = { "   ⚡️ NVIM 🚀 with 👽 Lua 🌛" }
