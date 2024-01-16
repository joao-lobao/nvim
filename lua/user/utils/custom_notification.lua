local namespace = vim.api.nvim_create_namespace("session-notify")
local config = {
	[vim.log.levels.INFO] = {
		icon = "",
		hl = "NotificationInfo",
		hl_emphasis = "NotificationInfoEmphasis",
	},
	[vim.log.levels.WARN] = {
		icon = "",
		hl = "NotificationWarn",
		hl_emphasis = "NotificationWarnEmphasis",
	},
	[vim.log.levels.ERROR] = {
		icon = "",
		hl = "NotificationError",
		hl_emphasis = "NotificationErrorEmphasis",
	},
}

function Notification(message, level, emphasis)
	local txt_emphasis = ""
	if emphasis ~= nil then
		txt_emphasis = emphasis .. " "
	end
	local buffer = vim.api.nvim_get_current_buf()
	local txt_icon = "    " .. config[level].icon .. "  "
	local txt_msg = message .. "    "
	local extmarks = vim.api.nvim_buf_get_extmarks(buffer, namespace, 0, -1, {})
	local id = 1

	-- id working also as an offset when there will be multiple active notifications
	if #extmarks > 0 then
		id = extmarks[#extmarks][1] + 2
	end
	local screen_topline = vim.fn.line("w0") - 2 + id
	vim.api.nvim_buf_set_extmark(buffer, namespace, screen_topline, 0, {
		id = id,
		virt_text = {
			{ txt_icon, config[level].hl },
			{ txt_emphasis, config[level].hl_emphasis },
			{ txt_msg, config[level].hl },
		},
		virt_text_pos = "right_align",
		priority = 50,
	})
	extmarks = vim.api.nvim_buf_get_extmarks(buffer, namespace, 0, -1, {})
	for _, extmark in ipairs(extmarks) do
		vim.fn.timer_start(5000, function()
			vim.api.nvim_buf_del_extmark(buffer, namespace, extmark[1])
		end)
	end
end
