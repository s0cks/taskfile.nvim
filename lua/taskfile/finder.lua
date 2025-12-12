local M = {}

---@param req? taskfile.lsp.GetTasksRequest
function M.task_finder(req)
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
