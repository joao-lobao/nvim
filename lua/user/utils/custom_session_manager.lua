local session_save = function()
	local session = vim.fn.fnamemodify(vim.v.this_session, ":t")
	if session == "" then
		print("No session is loaded")
		return
	end
	vim.cmd("mksession! " .. Session_dir .. session)
end

function SessionLoad(session)
	session_save()
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
vim.api.nvim_create_autocmd("VimLeave", {
	callback = function()
		session_save()
	end,
})