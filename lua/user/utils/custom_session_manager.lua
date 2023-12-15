local session_dir = "~/.config/nvim/session/"

function SessionLoad(session)
	SessionSave()
  vim.cmd("bufdo bw")
	vim.cmd("source " .. session_dir .. session)
end

function SessionSave()
	local session = vim.fn.fnamemodify(vim.v.this_session, ":t")
	if session == "" then
		print("No session is loaded")
		return
	end
	vim.cmd("mksession! " .. session_dir .. session)
end

function SessionDelete(session)
	vim.cmd(":call delete(expand('" .. session_dir .. session .. "'))")
end

function SessionCreate(session)
	vim.cmd("mksession! " .. session_dir .. session)
end

-- populate args with session names
function Get_session_names()
	local sessions = vim.fn.glob(session_dir .. "*", true, true)
	local session_names = {}
	for _, session in ipairs(sessions) do
		table.insert(session_names, vim.fn.fnamemodify(session, ":t"))
	end
	return session_names
end

vim.api.nvim_create_user_command("SLoad", ":lua SessionLoad(<f-args>)", { complete = Get_session_names, nargs = "?" })
vim.api.nvim_create_user_command("SCreate", ":lua SessionCreate(<f-args>)", { complete = Get_session_names, nargs = "?" })
vim.api.nvim_create_user_command("SDelete", ":lua SessionDelete(<f-args>)", { complete = Get_session_names, nargs = "?" })

-- close and save sessions on vim leave
vim.api.nvim_create_autocmd("VimLeave", {
	callback = function()
		SessionSave()
	end,
})
