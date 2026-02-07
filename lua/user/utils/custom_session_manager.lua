local session_exists = function(session)
	local find_session = vim.fs.find(session, { path = Session_dir, type = "file" })
	return #find_session > 0
end

SessionSave = function()
	local session = vim.fn.fnamemodify(vim.v.this_session, ":t")
	if session == "" then
		vim.notify("No session is loaded", vim.log.levels.INFO)
		return
	end
	vim.cmd("mksession! " .. Session_dir .. session)
	vim.notify(session .. " session saved", vim.log.levels.INFO)
end

function SessionLoad(session)
	if not session_exists(session) then
		vim.notify(session .. " session does not exist", vim.log.levels.ERROR)
		return
	end
	SessionSave()
	vim.cmd("bufdo bw")
	vim.cmd("source " .. Session_dir .. session)
	vim.notify(session .. " session is loaded ✅", vim.log.levels.INFO)
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
vim.api.nvim_set_keymap("n", "sc", ":SCreate ", opts)
vim.api.nvim_set_keymap("n", "sd", ":SDelete ", opts)

-- close and save sessions on vim leave
local group_session_manager = vim.api.nvim_create_augroup("CustomSessionManager", { clear = true })
vim.api.nvim_create_autocmd("VimLeave", {
	callback = function()
		SessionSave()
	end,
	group = group_session_manager,
})
