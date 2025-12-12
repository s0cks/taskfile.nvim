---@class Config
local default_config = {}

local M = {}
M.config = default_config

M.setup = function(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})
	vim.api.nvim_create_user_command("ListTasks", function()
		print("listing tasks....")
		for _, task in ipairs(M.list_all()) do
			print(" - " .. task)
		end
	end, {})
end

---Query the lsp client for a list of available tasks to run
---@param req? taskfile.lsp.GetTasksRequest
---@return table
function M.list_all(req)
	local lsp = require("taskfile.lsp")
	local client = lsp.find_taskfile_client()

	if not client then
		print("failed to find taskfile LSP client")
		return {}
	end

	local data, error = lsp.get_tasks_request_sync(client, req)
	if error then
		print("LSP error: " .. vim.inspect(error))
		return {}
	elseif not data then
		print("LSP returned empty response")
		return {}
	end

	local results = {}
	for _, task in ipairs(data) do
		table.insert(results, task.task.value)
	end
	return results
end

return M
