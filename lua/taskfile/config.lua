---@class taskfile.Opts
---@field notify? fun(msg, level, opts) The notify function

---@return taskfile.Opts
return {
	notify = vim.notify,
}
