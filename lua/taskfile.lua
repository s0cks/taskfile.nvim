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
  vim.filetype.add(require("taskfile.filetype"))

  vim.api.nvim_create_user_command("Task", function()
    M.select_task(M.list_tasks(), function(task)
      M.start_task_job(task.name)
    end)
  end, {})
end

--- List the available tasks
---@return taskfile.Task[]
function M.list_tasks()
  return util.list_tasks()
end

--- Open a select prompt for a list of tasks
---@param tasks taskfile.Task[] The tasks to select from
---@param on_choice fun(task: taskfile.Task) The callback when a choice is selected
---@param opts? taskfile.SelectOpts The opts to use
function M.select_task(tasks, on_choice, opts)
  return util.select_task(tasks, on_choice, opts)
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
