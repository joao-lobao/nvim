function Eggs()
  return {
    "🎅",
    "🎄",
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

function KillDucks(quantity)
  if quantity == nil then quantity = 1 end
  for i=quantity,1,-1 do require('duck').cook() end
end

vim.api.nvim_create_user_command("Hatch", ":lua require('duck').hatch(<f-args>)", { nargs = '?', complete = "customlist,v:lua.Eggs" })
vim.api.nvim_create_user_command("HatchKill", ":lua KillDucks(<f-args>)", { nargs = '?' })
