function Eggs()
  return {
    "🎅",
    "🎄",
    "☃️ ",
    "🦆",
    "🌈",
    "🚕",
    "🚓",
    "🚑",
    "🎁",
    "❤️ ",
    "☢️ ",
    "☣️ "
  }
end

vim.api.nvim_create_user_command("Hatch", ":lua require('duck').hatch(<f-args>)", { nargs = '?', complete = "customlist,v:lua.Eggs" })
vim.api.nvim_create_user_command("HatchKill", ":lua require('duck').cook()", {})
