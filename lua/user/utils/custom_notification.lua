local namespace = vim.api.nvim_create_namespace("session-notify")
local types = { "NotificationInfo", "NotificationWarn", "NotificationError" }
function Notification(message, level)
	if level == nil then
		level = 1
	end
	message = "  " .. message .. "  "
	vim.api.nvim_buf_set_extmark(0, namespace, vim.fn.line("w0"), 0, {
		id = 1,
		virt_text = {
			{ message, types[level] },
		},
		virt_text_pos = "right_align",
		priority = 50,
	})
	vim.fn.timer_start(5000, function()
		vim.api.nvim_buf_del_extmark(0, namespace, 1)
	end)
end
