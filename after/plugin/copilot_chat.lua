local chat = require("CopilotChat")
vim.keymap.set({ "n", "v" }, "<leader>ai", chat.toggle, { desc = "AI Toggle" })
vim.keymap.set({ "n", "v" }, "<leader>ac", ":CopilotChatCommit<CR>", { desc = "AI Commit" })
vim.keymap.set({ "n", "v" }, "<leader>ae", ":CopilotChat Explain<CR>", { desc = "AI Explain" })
vim.keymap.set({ "n", "v" }, "<leader>af", ":CopilotChat Fix<CR>", { desc = "AI Fix" })
vim.keymap.set({ "n", "v" }, "<leader>ao", ":CopilotChat Optimize<CR>", { desc = "AI Optimize" })
vim.keymap.set({ "n", "v" }, "<leader>ar", ":CopilotChat Review<CR>", { desc = "AI Review" })
vim.keymap.set({ "n" }, "<leader>ad", chat.reset, { desc = "AI Reset" })
vim.keymap.set({ "n", "v" }, "<leader>at", ":CopilotChat Tests<CR>", { desc = "AI Tests" })
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
