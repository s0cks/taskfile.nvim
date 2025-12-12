local M = {}

---@class taskfile.picker.TaskPickerOpts : snacks.picker.Config
---@field req? taskfile.lsp.GetTasksRequest
---@field run? taskfile.runner.RunOpts
local default_task_picker_opts = {}

---@param opts? taskfile.picker.TaskPickerOpts
function M.task_picker(opts)
	opts = vim.tbl_deep_extend("force", default_task_picker_opts, opts or {})
	local finders = require("taskfile.finder")
	Snacks.picker.pick({
		source = "tasks",
		finder = finders.task_finder(opts.req),
		title = "Taskfile tasks",
		format = "text",
		layout = {
			preset = "vertical",
		},
		preview = "none",
		confirm = opts.confirm or (require("taskfile.actions").run(opts.run)),
	})
end

return M
