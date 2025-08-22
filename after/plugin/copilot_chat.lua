-- import nvim-cmp plugin safely
local chat_status, chat = pcall(require, "CopilotChat")
if not chat_status then
	return
end

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

vim.keymap.set({ "n", "v" }, "<leader>aa", AiAsk, { desc = "AI Ask" })
vim.keymap.set({ "n", "v" }, "<leader>ai", chat.toggle, { desc = "AI Toggle" })
vim.keymap.set({ "n", "v" }, "<leader>ad", chat.reset, { desc = "AI Reset" })

chat.setup({
	prompts = {
		BetterNamings = {
			prompt = "> /COPILOT_REVIEW\n\nPlease suggest better names for the variables and functions in the selected code.",
		},
		Refactor = {
			prompt = "> /COPILOT_GENERATE\n\nRefactor the selected code.",
		},
	},
	mappings = {
		submit_prompt = {
			normal = "<CR>",
			insert = "<CR>",
		},
	},
})
