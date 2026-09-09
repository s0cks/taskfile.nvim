local util = require("taskfile.util")

local M = {}
local version = "2.0.0"

---@type taskfile.Opts
M.config = {}

function M.get_version()
  return version
end

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", require("taskfile.config"), opts or {})
end

--- List the available tasks
---@return taskfile.Task[]
function M.list_tasks()
  return util.list_tasks()
end

--- Start a job running the task
---@param task string The name of the task to run
---@param opts? taskfile.TaskJobOpts
function M.start_task_job(task, opts)
  opts = vim.tbl_deep_extend("force", {
    notify = M.config.notify,
  }, opts or {})
  util.start_task_job(task, opts)
end

return M
