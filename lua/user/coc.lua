vim.g.coc_global_extensions = {
  'coc-yank',
  'coc-tsserver',
  'coc-tslint-plugin',
  'coc-prettier',
  'coc-json',
  'coc-html',
  'coc-eslint',
  'coc-css',
  'coc-angular',
  'coc-vimlsp',
  'coc-git',
  'coc-markdownlint',
  'coc-markdown-preview-enhanced',
  'coc-marketplace',
  'coc-webview',
  'coc-emmet',
  'coc-tabnine',
  'coc-ultisnips',
  'coc-calc',
  'coc-explorer',
 }

vim.api.nvim_set_keymap('n', '<leader>y', ':<C-u>CocList -A --normal yank<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '=', ':CocCommand calc.append<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gd', '<Plug>(coc-definition)', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gr', '<Plug>(coc-references)', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dp', '<Plug>(coc-diagnostic-prev)', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dn', '<Plug>(coc-diagnostic-next)', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>di', '<Plug>(coc-diagnostic-info)', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>mo', ':CocCommand markdown-preview-enhanced.openPreview<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>mf', ':CocCommand markdownlint.fixAll<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>cg', ':CocCommand git.showCommit<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>e', '<Cmd>CocCommand explorer<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>f', ':CocFix<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gu', ':CocCommand git.chunkUndo<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gs', ':CocCommand git.chunkStage<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gk', ':CocCommand git.chunkInfo<CR>', { noremap = true })

-- Formatting selected code
vim.api.nvim_set_keymap('x', '<leader>p', '<Plug>(coc-format)', { noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>p', '<Plug>(coc-format)', { noremap = true, silent = true })

-- Symbol renaming.
vim.api.nvim_set_keymap('n', '<F2>', '<Plug>(coc-rename)', { noremap = true })


---------------BEGIN COC BOILERPLATE-------------
-- Create CocAction and CocFix command
vim.cmd [[
  command! -nargs=* -range CocAction :call coc#rpc#notify('codeActionRange', [<line1>, <line2>, <f-args>])
  command! -nargs=* -range CocFix    :call coc#rpc#notify('codeActionRange', [<line1>, <line2>, 'quickfix'])
]]

-- Some servers have issues with backup files, see #649.
vim.opt.backup = false
vim.opt.writebackup = false

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
vim.opt.updatetime = 300

-- Always show the signcolumn, otherwise it would shift the text each time
-- diagnostics appear/become resolved.
vim.opt.signcolumn = "yes"

local keyset = vim.keymap.set
-- Auto complete
function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Use tab for trigger completion with characters ahead and navigate.
-- NOTE: There's always complete item selected by default, you may want to enable
-- no select by `"suggest.noselect": true` in your configuration file.
-- NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
-- other plugin before putting this into your config.
local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

-- Make <CR> to accept selected completion item or notify coc.nvim to format
-- <C-g>u breaks current undo, please make your own choice.
keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

-- Use <c-j> to trigger snippets
keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
-- Use ç to trigger completion.
keyset("i", "ç", "coc#refresh()", {silent = true, expr = true})


-- Use K to show documentation in preview window.
function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end
keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent = true})


-- Highlight the symbol and its references when holding the cursor.
vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {
    group = "CocGroup",
    command = "silent call CocActionAsync('highlight')",
    desc = "Highlight symbol under cursor on CursorHold"
})

-- Setup formatexpr specified filetype(s).
vim.api.nvim_create_autocmd("FileType", {
    group = "CocGroup",
    pattern = "typescript,json",
    command = "setl formatexpr=CocAction('formatSelected')",
    desc = "Setup formatexpr specified filetype(s)."
})

-- Update signature help on jump placeholder.
vim.api.nvim_create_autocmd("User", {
    group = "CocGroup",
    pattern = "CocJumpPlaceholder",
    command = "call CocActionAsync('showSignatureHelp')",
    desc = "Update signature help on jump placeholder"
})

vim.api.nvim_create_user_command("Refactor", "call CocAction('refactor')", {})

-------------END COC BOILERPLATE-------------
