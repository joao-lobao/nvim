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

local function set_ext_mark(buffer, screen_topline, id, icon, msg, level)
	if vim.api.nvim_buf_is_loaded(buffer) then
		vim.api.nvim_buf_set_extmark(buffer, namespace, screen_topline, 0, {
			id = id,
			virt_text = {
				{ icon, config[level].icon_hl },
				{ msg, config[level].hl },
			},
			virt_text_pos = "right_align",
		})
	end
end

function Notification(message, level)
	local icon = " " .. config[level].icon .. " "
	local msg = " " .. message .. " "
	local buffer = vim.api.nvim_get_current_buf()
	local extmarks = vim.api.nvim_buf_get_extmarks(buffer, namespace, 0, -1, {})
	-- id working also as an offset when there will be multiple active notifications, or set to line 0
	local id = #extmarks > 0 and extmarks[#extmarks][1] + 2 or 2
	local line_count = vim.api.nvim_buf_line_count(buffer)
	local screen_topline = vim.fn.line("w0") - 2 + id
	-- check notification position, higher than buffer size
	screen_topline = screen_topline > line_count and 0 or screen_topline

	-- show
	set_ext_mark(buffer, screen_topline, id, icon, msg, level)
	-- hiding starts after 5 seconds
	vim.fn.timer_start(5000, function()
		-- hide
		if vim.api.nvim_buf_is_loaded(buffer) then
			vim.api.nvim_buf_del_extmark(buffer, namespace, id)
		end
	end)
end
