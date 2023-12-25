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
	-- stop all clients before deleting buffers and loading session
	local opened_bufs = vim.fn.getbufinfo({ buflisted = 1 })
	for _, buf in ipairs(opened_bufs) do
		vim.lsp.for_each_buffer_client(buf.bufnr, function(client)
			-- even though this stops in fact all clients, when loading session Lsp
			-- throws error message like a previous client is still running but in fact it's not
			-- a bug that can be ignored (it has to do with loading the session but
			-- if buffers where not Entered on before loading new session Lsp gets
			-- confused)
			client.stop()
		end)
	end
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
