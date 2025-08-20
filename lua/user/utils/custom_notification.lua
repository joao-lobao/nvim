local namespace = vim.api.nvim_create_namespace("notify")
local config = {
	[vim.log.levels.INFO] = {
		icon = "I",
		icon_hl = "NotificationInfoInv",
		hl = "NotificationInfo",
	},
	[vim.log.levels.WARN] = {
		icon = "W",
		icon_hl = "NotificationWarnInv",
		hl = "NotificationWarn",
	},
	[vim.log.levels.ERROR] = {
		icon = "X",
		icon_hl = "NotificationErrorInv",
		hl = "NotificationError",
	},
}

local notifications = {}
local function set_ext_mark(modifier, col, buffer, screen_topline, id, icon, msg, level, total_length)
	vim.fn.timer_start(10, function()
		if vim.api.nvim_buf_is_loaded(buffer) then
			if modifier == "show" then
				col = col - 1
			else
				col = col + 1
			end

			vim.api.nvim_buf_set_extmark(buffer, namespace, screen_topline, 0, {
				id = id,
				virt_text = {
					{ icon, config[level].icon_hl },
					{ msg, config[level].hl },
				},
				virt_text_win_col = col,
				priority = 50,
			})
		end
	end, { ["repeat"] = total_length })
end

function Notification(message, level)
	local icon = " " .. config[level].icon .. " "
	local msg = " " .. message .. " "
	local total_length = #icon + #msg
	local buffer = vim.api.nvim_get_current_buf()
	local extmarks = vim.api.nvim_buf_get_extmarks(buffer, namespace, 0, -1, {})
	-- id working also as an offset when there will be multiple active notifications, or set to line 0
	local id = #extmarks > 0 and extmarks[#extmarks][1] + 2 or 2
	local line_count = vim.api.nvim_buf_line_count(buffer)
	local screen_topline = vim.fn.line("w0") - 2 + id
	-- check notification position, higher than buffer size
	screen_topline = screen_topline > line_count and 0 or screen_topline
	local width = vim.api.nvim_win_get_width(0) - 7

	-- animate notification (can also be achieved with loop timer)
	-- show
	set_ext_mark("show", width, buffer, screen_topline, id, icon, msg, level, total_length)
	-- hiding starts after 5 seconds
	vim.fn.timer_start(5000, function()
		set_ext_mark("hide", width - total_length, buffer, screen_topline, id, icon, msg, level, total_length)
	end)

	-- clean notification
	vim.fn.timer_start(5100 + (total_length * 10), function()
		-- if extmark still exists, delete it
		if vim.api.nvim_buf_is_valid(buffer) then
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
