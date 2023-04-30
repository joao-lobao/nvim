local setup, chatgpt = pcall(require, "chatgpt")
if not setup then
	return
end

-- configure/setup chatgpt
chatgpt.setup({
	popup_input = {
		submit = "<Enter>",
	},
})
