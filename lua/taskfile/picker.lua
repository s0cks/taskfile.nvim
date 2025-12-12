local M = {}

---@class taskfile.picker.TaskPickerOpts
---@field req? taskfile.lsp.GetTasksRequest
local default_task_picker_opts = {}

---@param opts? taskfile.picker.TaskPickerOpts
function M.task_picker(opts)
	opts = vim.tbl_deep_extend("force", default_task_picker_opts, opts)
	local finder = require("taskfile.finder")
	Snacks.picker.pick({
		source = "tasks",
		finder = finder(opts.req),
		title = "Taskfile tasks",
	})
end

return M
