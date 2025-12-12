local M = {}

---@class taskfile.find_taskfile_client_opts
---@field bufnr? number The buffer number to use to search attached lsp clients. defaults to 0, the current buffer
---@field client_name? string The client name to search for. defaults to 'taskfile'
local default_find_taskfile_client_opts = {
	bufnr = 0,
	client_name = "taskfile",
}

---@param opts? taskfile.find_taskfile_client_opts
---@return vim.lsp.Client|nil
function M.find_taskfile_client(opts)
	opts = vim.tbl_deep_extend("force", default_find_taskfile_client_opts, opts or {})
	local clients = vim.lsp.get_clients({ bufnr = opts.bufnr })

	if #clients == 0 then
		---TODO(@s0cks): probably should log this somehow?
		return nil
	end

	for _, client in ipairs(clients) do
		if client.name == opts.client_name then
			return client
		end
	end

	return nil
end

---@class taskfile.lsp.GetTasksRequest
---@field fsPath? string The absolute path of the Taskfile to query
local default_get_tasks_request = {}

---@param client vim.lsp.Client The client to make the request w/
---@param req? taskfile.lsp.GetTasksRequest The request to make
function M.get_tasks_request_sync(client, req)
	req = vim.tbl_deep_extend("force", default_get_tasks_request, req or {})
	if not req.fsPath then
		req.fsPath = vim.fn.expand("%p")
	end
	local data, error = client:request_sync("extension/getTasks", req)
	if error then
		---TODO(@s0cks): probaby should log this, client side error
		---print("LSP client error: " .. vim.inspect(error))
		return nil, error
	elseif not data then
		---TODO(@s0cks): probably should also log this, LSP returned empty response
		---print("LSP no data returned")
		return {}, nil
	elseif data.err then
		---TODO(@s0cks): probably should log this, LSP responded w/ an error
		---print("LSP responded w/ error: " .. vim.inspect(data.err))
		return nil, data.err
	end
	return data.result, nil
end

---@param client vim.lsp.Client The client to make the request w/
---@param req? taskfile.lsp.GetTasksRequest The request to make
function M.get_vars_request_sync(client, req)
	req = vim.tbl_deep_extend("force", default_get_tasks_request, req)
	if not req.fsPath then
		req.fsPath = vim.fn.expand("%p")
	end
	local data, error = client:request_sync("extension/getVars", req)
	if error then
		---TODO(@s0cks): probaby should log this, client side error
		---print("LSP client error: " .. vim.inspect(error))
		return nil, error
	elseif not data then
		---TODO(@s0cks): probably should also log this, LSP returned empty response
		---print("LSP no data returned")
		return {}, nil
	elseif data.err then
		---TODO(@s0cks): probably should log this, LSP responded w/ an error
		---print("LSP responded w/ error: " .. vim.inspect(data.err))
		return nil, data.err
	end
	return data.result, nil
end

return M
