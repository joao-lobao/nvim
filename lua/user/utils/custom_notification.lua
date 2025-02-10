local namespace = vim.api.nvim_create_namespace("notify")
local config = {
	[vim.log.levels.INFO] = {
		icon = "I",
		icon_hl = "NotificationInfoInv",
		hl = "NotificationInfo",
		hl_blur = "NotificationInfoBlur",
	},
	[vim.log.levels.WARN] = {
		icon = "W",
		icon_hl = "NotificationWarnInv",
		hl = "NotificationWarn",
		hl_blur = "NotificationWarnBlur",
	},
	[vim.log.levels.ERROR] = {
		icon = "X",
		icon_hl = "NotificationErrorInv",
		hl = "NotificationError",
		hl_blur = "NotificationErrorBlur",
	},
}

local notifications = {}

function Notification(message, level)
	local buffer = vim.api.nvim_get_current_buf()
	local extmarks = vim.api.nvim_buf_get_extmarks(buffer, namespace, 0, -1, {})
	-- id working also as an offset when there will be multiple active notifications, or set to line 0
	local id = #extmarks > 0 and extmarks[#extmarks][1] + 2 or 2
	local line_count = vim.api.nvim_buf_line_count(buffer)
	local screen_topline = vim.fn.line("w0") - 2 + id
	-- check notification position, higher than buffer size
	screen_topline = screen_topline > line_count and 0 or screen_topline
	vim.api.nvim_buf_set_extmark(buffer, namespace, screen_topline, 0, {
		id = id,
		virt_text = {
			{ " " .. config[level].icon .. " ", config[level].icon_hl },
			{ " " .. message .. " ", config[level].hl },
		},
		-- center notification horizontally
		virt_text_win_col = math.floor(vim.api.nvim_win_get_width(0) / 2) - math.floor(#message / 2) - 6,
		priority = 50,
	})

	vim.fn.timer_start(5000, function()
		if vim.api.nvim_buf_is_loaded(buffer) then
			vim.api.nvim_buf_del_extmark(buffer, namespace, id)
		end
	end)
	table.insert(notifications, { message = message, level = level })
end

function Get_last_notification()
	local index = #notifications
	if #notifications > 0 then
		vim.notify(notifications[index].message, notifications[index].level)
	end
end

vim.api.nvim_create_user_command("LastNotification", ":lua Get_last_notification()", {})
