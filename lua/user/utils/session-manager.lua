vim.api.nvim_create_user_command("SessionLoad", ":bufdo! | bd", {})

local session_dir = "~/.config/nvim/session/"

-- TODO: make sessions return dynamically 2022-11-16
function Sessions()
	return {
		"Crypto Watcher",
		"Dotfiles",
		"JoaoLobao",
		"Muxinator",
		"Notes",
		"VimConfig",
	}
end

-- Session Load
function SessionLoad(session)
	SessionClose()
	vim.cmd("so " .. session_dir .. session)
end
vim.api.nvim_create_user_command(
	"SLoad",
	":lua SessionLoad(<f-args>)",
	{ nargs = "?", complete = "customlist,v:lua.Sessions" }
)

-- Session Save
function SessionSave(session)
	vim.cmd("mks! " .. session_dir .. session)
end
vim.api.nvim_create_user_command(
	"SSave",
	":lua SessionSave(<f-args>)",
	{ nargs = "?", complete = "customlist,v:lua.Sessions" }
)

-- Session Close
function SessionClose()
	local session = vim.fn.fnamemodify(vim.v.this_session, ":t")
	if session == "" then
		print("No session is loaded")
	else
		SessionSave(session)
		vim.cmd("silent bufdo! | bd")
	end
end
vim.api.nvim_create_user_command("SClose", ":lua SessionClose()", {})

-- Session Delete
function SessionDelete(session)
	vim.cmd(":call delete('" .. session_dir .. session .. "')")
end
vim.api.nvim_create_user_command(
	"SDelete",
	":lua SessionDelete(<f-args>)",
	{ nargs = "?", complete = "customlist,v:lua.Sessions" }
)

-- close and save sessions on vim leave
vim.api.nvim_create_autocmd("VimLeave", {
	callback = function()
		SessionClose()
	end,
})
