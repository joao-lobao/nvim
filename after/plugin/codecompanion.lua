local cc_status, codecompanion = pcall(require, "codecompanion")
if not cc_status then
	return
end

codecompanion.setup({
	{
		strategies = {
			chat = {
				adapter = "openrouter",
				slash_commands = {
					["file"] = {
						-- Location to the slash command in CodeCompanion
						callback = "strategies.chat.slash_commands.file",
						description = "Select a file using Telescope",
						opts = {
							provider = "telescope",
							contains_code = true,
						},
					},
					["buffer"] = {
						-- Location to the slash command in CodeCompanion
						callback = "strategies.chat.slash_commands.buffer",
						description = "Select a file using Telescope",
						opts = {
							provider = "telescope",
							contains_code = true,
						},
					},
				},
			},
		},
		adapters = {
			openrouter = function()
				return codecompanion.adapters.extend("openai_compatible", {
					env = {
						api_key = os.getenv("OPENROUTER_API_KEY"),
						url = "https://openrouter.ai/api",
						chat_url = "/v1/chat/completions",
					},
					schema = {
						model = {
							-- default = "qwen/qwen3-coder",
							default = "qwen/qwen3-coder:free",
							-- default = "anthropic/claude-sonnet-4"
							-- default = "anthropic/claude-3.7-sonnet"
							-- default = "deepseek/deepseek-chat-v3-0324:free",
						},
						-- this temperature attribute configuration is just an example not for default = "deepseek-r1-671b"
						-- temperature = {
						-- 	order = 2,
						-- 	mapping = "parameters",
						-- 	type = "number",
						-- 	optional = true,
						-- 	default = 0.8,
						-- 	desc = "What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. We generally recommend altering this or top_p but not both.",
						-- 	validate = function(n)
						-- 		return n >= 0 and n <= 2, "Must be between 0 and 2"
						-- 	end,
						-- },
					},
				})
			end,
		},
		default_adapter = "openrouter",
		display = {
			chat = {
				intro_message = "Welcome to CodeCompanion ✨! Press ? for options",
				show_header_separator = false,
				separator = "─", -- The separator between the different messages in the chat buffer
				show_references = true, -- Show references (from slash commands and variables) in the chat buffer?
				show_settings = true, -- Show LLM settings at the top of the chat buffer?
				show_token_count = true, -- Show the token count for each response?
				start_in_insert_mode = false, -- Open the chat buffer in insert mode?
				window = {
					width = 0.5, -- Width of the chat window
				},
			},
			action_palette = {
				width = 0.5,
				height = 0.5,
				prompt = "Prompt ", -- Prompt used for interactive LLM calls
				provider = "telescope", -- default|telescope|mini_pick
				opts = {
					show_default_actions = true, -- Show the default actions in the action palette?
					show_default_prompt_library = true, -- Show the default prompt library in the action palette?
				},
			},
		},
	},
})

vim.keymap.set("n", "<leader>cc", function()
	codecompanion.toggle()
end, { desc = "CodeCompanionChat Toggle" })
vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })

vim.g.codecompanion_in_use = true
