require("user.utils.constants")
require("user.utils.custom_alternate")
require("user.utils.custom_git")
require("user.utils.custom_session_manager")
require("user.utils.custom_statusline")
require("user.utils.custom_winbar")
require("user.utils.luasnip")
require("user.utils.netrw")
require("user.utils.nvim_telescope")
require("user.utils.autocommands")

-- TODO: remove this
-- unused constants
-- require("user.utils.custom_git")
-- require("user.utils.custom_goto")
-- require("user.utils.custom_statusline") statusline can be improved with nvim_eval_statusline
-- require("user.utils.custom_winbar") winbar can be improved by using WinBarNC and nvim_eval_statusline
-- require("user.utils.netrw") netrw can also be disabled by setting g:loaded_netrwPlugin to 1 and g:loaded_netrw to 1
-- custom null_ls/none-ls feature and extra_args = get_eslint_rules() which is responsible for long startup time

-- netrw
-- vim.g.loaded_netrwPlugin = 1
-- vim.g.loaded_netrw = 1
-- statusline and winbar
-- local dark_gray = "#282a36"
-- local green = "#50fa7b"
-- local red = "#ff5555"
-- local light_purple = "#bd93f9"
-- local bright_orange = "#fe8019"
-- vim.api.nvim_set_hl(0, "MsgArea", { bg = dark_gray, fg = green })
-- vim.api.nvim_set_hl(0, "ErrorMsg", { bg = dark_gray, fg = red })
-- vim.api.nvim_set_hl(0, "StatusLine", { bg = dark_gray, fg = bright_orange })
-- vim.api.nvim_set_hl(0, "WinBar", { bg = dark_gray, fg = light_purple })
-- vim.api.nvim_set_hl(0, "CustomMod", { bg = green, fg = dark_gray })
-- winbar
-- vim.o.winbar = "%=%#StatusLine# %y %#Winbar#%F %#CustomMod#%m%*%="
