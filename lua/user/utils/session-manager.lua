local session_dir = "~/.config/nvim/session/"
local dummy_session = "EmptySession"

-- Session Load
function SessionLoad(session)
	SessionClose()
	vim.cmd("so " .. session_dir .. session)
end
vim.api.nvim_create_user_command("SLoad", ":lua SessionLoad(<f-args>)", { nargs = "?" })

-- Session Save
function SessionSave(session)
	vim.cmd("mks! " .. session_dir .. session)
end
vim.api.nvim_create_user_command("SSave", ":lua SessionSave(<f-args>)", { nargs = "?" })

function CreateDummySession()
	-- creates dummy session in case it does not exist
	if vim.fn.filereadable(vim.fn.expand("'" .. session_dir .. dummy_session .. "'")) == 0 then
		vim.cmd("silent bufdo bd")
		SessionSave(dummy_session)
	end
end

-- Session Close
function SessionClose()
	local session = vim.fn.fnamemodify(vim.v.this_session, ":t")
	if session == "" then
		print("No session is loaded")
		-- create dummy session if not exists
		CreateDummySession()
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
		local session = vim.fn.fnamemodify(vim.v.this_session, ":t")
    -- if no session loaded and empty buffer
		if session == "" and vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then
			require("telescope.builtin").common_actions()
		end
	end,
})
