local namespace = vim.api.nvim_create_namespace("session-notify")
local config = {
	[vim.log.levels.INFO] = {
		icon = "      ",
		hl = "NotificationInfo",
		hl_emphasis = "NotificationInfoEmphasis",
	},
	[vim.log.levels.WARN] = {
		icon = "      ",
		hl = "NotificationWarn",
		hl_emphasis = "NotificationWarnEmphasis",
	},
	[vim.log.levels.ERROR] = {
		icon = "      ",
		hl = "NotificationError",
		hl_emphasis = "NotificationErrorEmphasis",
	},
}

function Notification(message, level, emphasis, timeout)
	-- emphasis = emphasis ~= nil and emphasis .. " " or ""
	-- timeout = timeout ~= nil and timeout or 5000
	-- local buffer = vim.api.nvim_get_current_buf()
	-- local extmarks = vim.api.nvim_buf_get_extmarks(buffer, namespace, 0, -1, {})
	-- -- id working also as an offset when there will be multiple active notifications
	-- local id = #extmarks > 0 and extmarks[#extmarks][1] + 2 or 1
	-- local line_count = vim.api.nvim_buf_line_count(buffer)
	-- local screen_topline = vim.fn.line("w0") - 2 + id
	-- -- check notification position, higher than buffer size
	-- screen_topline = screen_topline > line_count and 0 or screen_topline
	-- vim.api.nvim_buf_set_extmark(buffer, namespace, screen_topline, 0, {
	-- 	id = id,
	-- 	virt_text = {
	-- 		{ config[level].icon, config[level].hl },
	-- 		{ emphasis, config[level].hl_emphasis },
	-- 		{ message .. "    ", config[level].hl },
	-- 	},
	-- 	virt_text_pos = "right_align",
	-- 	priority = 50,
	-- })
	-- vim.fn.timer_start(timeout, function()
	-- 	if vim.api.nvim_buf_is_loaded(buffer) then
	-- 		vim.api.nvim_buf_del_extmark(buffer, namespace, id)
	-- 	end
	-- end)
end
