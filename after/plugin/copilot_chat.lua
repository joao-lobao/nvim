local chat = require("CopilotChat")

AiAsk = function()
	vim.ui.input({
		prompt = "AI Question> ",
	}, function(input)
		if input and input ~= "" then
			chat.ask(input)
		end
	end)
end
vim.api.nvim_create_user_command("AiAsk", AiAsk, {})

vim.keymap.set({ "n", "v" }, "<leader>aa", AiAsk, { desc = "AI Toggle" })
vim.keymap.set({ "n", "v" }, "<leader>ai", chat.toggle, { desc = "AI Toggle" })
vim.keymap.set({ "n", "v" }, "<leader>ad", chat.reset, { desc = "AI Reset" })
vim.keymap.set({ "n" }, "<Esc>", chat.close, { desc = "AI Close" })

chat.setup({
	prompts = {
		BetterNamings = {
			prompt = "> /COPILOT_REVIEW\n\nPlease suggest better names for the variables and functions in the selected code.",
		},
		Refactor = {
			prompt = "> /COPILOT_GENERATE\n\nRefactor the selected code.",
		},
	},
})
