require("nvim-tree").setup({
  update_focused_file = {
    enable = true,
    update_root = true,
  },
  view = {
    mappings = {
      list = {
        { key = { "l" }, action = "edit" },
        { key = "h", action = "close_node" },
      },
    },
  },
  actions = {
    open_file = {
      quit_on_open = true,
    },
  },
})
vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
