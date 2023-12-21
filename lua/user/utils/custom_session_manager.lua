SessionSave = function()
	local session = vim.fn.fnamemodify(vim.v.this_session, ":t")
	if session == "" then
		print("No session is loaded")
		return
	end
	vim.cmd("mksession! " .. Session_dir .. session)
end

function SessionLoad(session)
	SessionSave()
	vim.cmd("bufdo bw")
	vim.cmd("source " .. Session_dir .. session)
end

function SessionDelete(session)
	vim.cmd(":call delete(expand('" .. Session_dir .. session .. "'))")
end

function SessionCreate(session)
	vim.cmd("mksession! " .. Session_dir .. session)
end

vim.api.nvim_create_user_command("SLoad", ":lua SessionLoad(<f-args>)", { complete = Get_sessions_names, nargs = "?" })
vim.api.nvim_create_user_command(
	"SCreate",
	":lua SessionCreate(<f-args>)",
	{ complete = Get_sessions_names, nargs = "?" }
)
vim.api.nvim_create_user_command(
	"SDelete",
	":lua SessionDelete(<f-args>)",
	{ complete = Get_sessions_names, nargs = "?" }
)

-- close and save sessions on vim leave
local group_session_manager = vim.api.nvim_create_augroup("CustomSessionManager", { clear = true })
vim.api.nvim_create_autocmd("VimLeave", {
	callback = function()
		SessionSave()
	end,
	group = group_session_manager,
})
