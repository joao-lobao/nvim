local chat = require("CopilotChat")
vim.keymap.set({ "n", "v" }, "<leader>ai", chat.toggle, { desc = "AI Toggle" })
vim.keymap.set({ "n" }, "<leader>ad", chat.reset, { desc = "AI Reset" })
-- AI ask
vim.keymap.set({ "n", "v" }, "<leader>aa", function()
	vim.ui.input({
		prompt = "AI Question> ",
	}, function(input)
		if input and input ~= "" then
			chat.ask(input)
		end
	end)
end, { desc = "AI Quick Chat" })

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
