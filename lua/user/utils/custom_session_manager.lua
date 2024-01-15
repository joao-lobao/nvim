SessionSave = function()
	local session = vim.fn.fnamemodify(vim.v.this_session, ":t")
	if session == "" then
		vim.notify("No session is loaded", vim.log.levels.INFO)
		return
	end
	vim.cmd("mksession! " .. Session_dir .. session)
	vim.notify(session .. " session saved", vim.log.levels.INFO)
	Notification("session saved", vim.log.levels.INFO, session)
end

function SessionLoad(session)
	SessionSave()
	-- stop all clients before deleting buffers and loading session
	-- even though this stops in fact all clients, when loading session Lsp
	-- throws error message like a previous client is still running but in fact it's not
	-- a bug that can be ignored (it has to do with loading the session but
	-- if buffers where not Entered on before loading new session Lsp gets
	-- confused)
	vim.lsp.stop_client(vim.lsp.get_active_clients())
	vim.cmd("bufdo bw")
	vim.cmd("source " .. Session_dir .. session)
	Notification("session is loaded", vim.log.levels.INFO, session)
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
local opts = { noremap = true, silent = false }
vim.api.nvim_set_keymap("n", "sl", ":SLoad ", opts)

-- close and save sessions on vim leave
local group_session_manager = vim.api.nvim_create_augroup("CustomSessionManager", { clear = true })
vim.api.nvim_create_autocmd("VimLeave", {
	callback = function()
		SessionSave()
	end,
	group = group_session_manager,
})
