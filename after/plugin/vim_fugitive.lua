local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "gs", ":G<CR>", opts)

vim.api.nvim_set_keymap("n", "gl", ":Gclog<CR><C-w>j", opts)
vim.api.nvim_set_keymap("n", "g%", ":Gclog -- %<CR><C-w>j", opts)

vim.api.nvim_set_keymap("n", "<leader>gd", ":Gdiffsplit<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>gh", ":diffget //2<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>gl", ":diffget //3<CR>", opts)

vim.api.nvim_set_keymap("n", "gb", ":Git blame<CR>", opts)

-- get last commit message
vim.api.nvim_create_user_command("GitLastCommit", "Git show -1", {})

-- example on how to create git gutter signs
-- vim.api.nvim_command("sign define diffchange text=󰏭 texthl=GruvboxAquaBold")
-- vim.api.nvim_command("sign place 1 line=" .. line_nr .. " name=diffchange file=" .. path)
-- vim.api.nvim_command("sign undefine diffchange")

-- hunks navigation
ToggleDiffView = function()
  if vim.o.diff == false then
    vim.api.nvim_command("Gdiffsplit")
  else
    vim.api.nvim_command("q")
  end

end

vim.api.nvim_set_keymap("n", "vd", "<cmd>lua ToggleDiffView()<CR>", opts)
vim.api.nvim_set_keymap("n", "c<", "[c", opts)
vim.api.nvim_set_keymap("n", "c>", "]c", opts)
vim.api.nvim_set_keymap("n", "<leader>gp", "[c", opts)
vim.api.nvim_set_keymap("n", "<leader>gn", "]c", opts)

-- git stage/reset hunks
vim.api.nvim_set_keymap("n", "<leader>gu", ":diffput<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>gs", ":diffget<CR>", opts)

-- helper keymaps
-- ( or c< or <leader>gp - goto previous hunk
-- ) or c> or <leader>gn - goto next hunk
-- do or <leader>gs - goto stage hunk
-- dp or <leader>gu - goto reset hunk
