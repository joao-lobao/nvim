local function my_on_attach(bufnr)
	local api = require("nvim-tree.api")
	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

  api.config.mappings.default_on_attach(bufnr)
	vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
	vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
	vim.keymap.set("n", "q", api.tree.close, opts("Close"))
end

require("nvim-tree").setup({
	on_attach = my_on_attach,
	update_focused_file = {
		enable = true,
		update_root = true,
	},
	actions = {
		open_file = {
			quit_on_open = true,
		},
	},
})
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)
