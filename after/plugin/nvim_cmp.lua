-- import nvim-cmp plugin safely
local cmp_status, cmp = pcall(require, "cmp")
if not cmp_status then
	return
end

-- import luasnip plugin safely
local luasnip_status, luasnip = pcall(require, "luasnip")
if not luasnip_status then
	return
end

-- load vs-code like snippets from plugins (e.g. friendly-snippets)
require("luasnip/loaders/from_vscode").lazy_load()

cmp.setup({
	completion = {
		completeopt = "menu,menuone,preview,noselect",
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<Tab>"] = cmp.mapping.select_next_item(), -- navigate to next item
		["<S-Tab>"] = cmp.mapping.select_prev_item(), -- navigate to previous item
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
		["<C-e>"] = cmp.mapping.abort(), -- close completion window
		[";"] = cmp.mapping.confirm({ select = true }),
		["<CR>"] = cmp.mapping.confirm({ select = false }),
	}),

	-- sources for autocompletion
	sources = cmp.config.sources({
		{ name = "path" }, -- file system paths
		{ name = "luasnip" }, -- snippets
		{ name = "nvim_lsp" }, -- lsp
		{ name = "spell" }, -- spell check
		{ name = "buffer" }, -- text within current buffer
		{ name = "calc" }, -- text for math operations
	}),
	-- configure cmp for vs-code like icons
	formatting = {
		format = function(entry, vim_item)
			-- use vim_item.kind to customize cmp text
			vim_item.kind = ({
				nvim_lsp = "LSP",
				spell = "Spell",
				path = "Path",
				buffer = "Buffer",
				luasnip = "Luasnip",
				calc = "Math",
			})[entry.source.name]

			-- use vim_item.menu to customize cmp icon
			vim_item.menu = ({
				nvim_lsp = "󰅟 ",
				spell = "󰓆",
				path = " ",
				buffer = "󰦪",
				luasnip = "",
				calc = "",
			})[entry.source.name]
			return vim_item
		end,
	},
})
