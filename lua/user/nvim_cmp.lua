-- import utils file
require("user.utils.nvim_cmp")

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

-- import lspkind plugin safely
local lspkind_status, lspkind = pcall(require, "lspkind")
if not lspkind_status then
	return
end

-- load vs-code like snippets from plugins (e.g. friendly-snippets)
require("luasnip/loaders/from_vscode").lazy_load()

vim.opt.completeopt = "menu,menuone,noselect"

-- helper function for super tab functionality (not in youtube nvim video)
local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
		["<C-e>"] = cmp.mapping.abort(), -- close completion window
		["<CR>"] = cmp.mapping.confirm({ select = false }),

		-- super tab functionality
		["<Tab>"] = cmp.mapping(function(fallback) -- use tab for next suggestion
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback) -- use shift-tab for prev suggestion
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	-- sources for autocompletion
	sources = cmp.config.sources({
		{ name = "calc" }, -- cmp calc
		{ name = "path" }, -- file system paths
		{ name = "ultisnips" }, -- snippets
		{ name = "luasnip" }, -- snippets
		{ name = "nvim_lsp" }, -- lsp
		{ name = "buffer" }, -- text within current buffer
		{ name = "cmp_tabnine" }, -- tabnine
		{ name = "emojis" }, -- custom emojis
	}),
	-- configure lspkind for vs-code like icons
	formatting = {
		format = lspkind.cmp_format({
			maxwidth = 50,
			ellipsis_char = "...",

			before = function(entry, vim_item)
				vim_item.menu = ({
					calc = "CALC",
					nvim_lsp = "ﲳ",
					path = "ﱮ",
					buffer = "﬘",
					luasnip = "",
					ultisnips = "US",
					cmp_tabnine = "TN",
					emojis = "😀",
				})[entry.source.name]
				return vim_item
			end,
		}),
	},
})
