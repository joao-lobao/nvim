-- for shorthand usage
local nm = require("neo-minimap")

nm.clear_all()
nm.source_on_save("/home/ziontee113/.config/nvim/lua/plugins/neo-minimap/")

-- Typescript React
nm.set("zi", { "typescript", "typescriptreact", "javascriptreact" }, {
	query = [[
;; query
((method_definition) @cap)
((function_declaration) @cap)
((identifier) @cap (#vim-match? @cap "^use.*"))
  ]],
})
