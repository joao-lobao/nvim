-- import luasnip plugin safely
local luasnip_status, luasnip = pcall(require, "luasnip")
if not luasnip_status then
	return
end

local snip = luasnip.snippet
local text = luasnip.text_node
local insert = luasnip.insert_node
local func = luasnip.function_node
local repeater = require("luasnip.extras").rep

local date = function()
	return { os.date("%d/%m/%Y") }
end

local log_warn_snip = function()
	return {
		snip({
			trig = "cw",
			name = "console.warn",
			desc = "console warn",
		}, {
			text({ "console.warn(" }),
			insert(1, "test"),
			text({ ")" }),
		}),
	}
end

local log_snip = function()
	return {
		snip({
			trig = "cl",
			name = "console.log",
			desc = "console log",
		}, {
			text({ "console.log(" }),
			insert(1, "test"),
			text({ ")" }),
		}),
	}
end

luasnip.add_snippets(nil, {
	all = {
		snip({
			trig = "meta",
			name = "Metadata",
			desc = "Comments/notes metadata ",
		}, {
			text({ "---", "title: " }),
			insert(1, "note_title"),
			text({ "", "date created: " }),
			func(date, {}),
			text({ "", "tags: [" }),
			repeater(1),
			insert(2),
			text({ "]" }),
			text({ "", "---" }),
		}),
	},
	javascriptreact = vim.list_extend(log_snip(), log_warn_snip()),
	javascript = vim.list_extend(log_snip(), log_warn_snip()),
	typescriptreact = vim.list_extend(log_snip(), log_warn_snip()),
	typescript = vim.list_extend(log_snip(), log_warn_snip()),
})
