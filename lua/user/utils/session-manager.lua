local session_dir = "~/.config/nvim/session/"
local dummy_session = "Connect to Workspace"

-- Session Load
function SessionLoad(session)
	SessionClose()
	vim.cmd("so " .. session_dir .. session)
end
vim.api.nvim_create_user_command(
	"SLoad",
	":lua SessionLoad(<f-args>)",
	{ nargs = "?" }
)

-- Session Save
function SessionSave(session)
	vim.cmd("mks! " .. session_dir .. session)
end
vim.api.nvim_create_user_command("SSave", ":lua SessionSave(<f-args>)", { nargs = "?" })

-- Session Close
function SessionClose()
	local session = vim.fn.fnamemodify(vim.v.this_session, ":t")
	if session == "" then
		print("No session is loaded")
	else
		if session ~= dummy_session then
			SessionSave(session)
		end
		vim.cmd("so " .. session_dir .. dummy_session)
		vim.cmd("silent bufdo bd")
	end
end
vim.api.nvim_create_user_command("SClose", ":lua SessionClose()", {})

-- Session Delete
function SessionDelete(session)
	vim.cmd(":call delete(expand('" .. session_dir .. session .. "'))")
end
vim.api.nvim_create_user_command("SDelete", ":lua SessionDelete(<f-args>)", { nargs = "?" })

-- close and save sessions on vim leave
vim.api.nvim_create_autocmd("VimLeave", {
	callback = function()
		SessionClose()
	end,
})

-- command to run on vim startup
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		SessionLoad(dummy_session)
		require("telescope.builtin").common_actions()
	end,
})
