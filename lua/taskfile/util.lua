local M = {}

local function create_task_buffer()
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_set_option_value("buftype", "nofile", {
		buf = buf,
	})
	vim.api.nvim_set_option_value("swapfile", false, {
		buf = buf,
	})
	vim.api.nvim_set_option_value("modifiable", false, {
		buf = buf,
	})
	return buf
end

local function slice(tbl, first, last, step)
	local sliced = {}
	first = first or 1
	last = last or #tbl
	step = step or 1
	if first < 0 then
		first = #tbl + first + 1
	end

	if last < 0 then
		last = #tbl + last + 1
	end

	for i = first, last, step do
		table.insert(sliced, tbl[i])
	end

	return sliced
end

---@class taskfile.Task
---@field name string The name of the task
---@field desc string The description of the task

--- List the available tasks
---@return taskfile.Task[]
function M.list_tasks()
	local out = vim.fn.system("task --list-all")
	local lines = vim.split(out, "\n")
	lines = slice(lines, 2)

	local items = {}

	for _, line in ipairs(lines) do
		local name = string.match(line, "[* ]+(%w+):")
		local desc = string.match(line, ":(.*)$")

		if name then
			table.insert(items, {
				name = name,
				desc = desc,
			})
		end
	end

	return items
end

---@class taskfile.SelectOpts : vim.ui.select.Opts
local default_select_task_opts = {
	prompt = "Which Task?",
	format_item = function(item)
		return item.name .. " " .. item.desc
	end,
}

--- Open a select prompt for a list of tasks
---@param tasks taskfile.Task[] The tasks to select from
---@param on_choice fun(task: taskfile.Task) The callback when a choice is selected
---@param opts? taskfile.SelectOpts The opts to use
function M.select_task(tasks, on_choice, opts)
	opts = vim.tbl_deep_extend("force", default_select_task_opts, opts or {})
	vim.ui.select(tasks, opts, function(choice)
		if choice then
			on_choice(choice)
		end
	end)
end

---@class taskfile.TaskJobOpts
---@field notify? fun(msg, level, opts) The notify function
---@field on_finished? fun() The callback to invoke when finished
local default_start_task_job_opts = {}

--- Start a task job
---@param task string The name of the task to run
---@param opts? taskfile.TaskJobOpts
function M.start_task_job(task, opts)
	opts = vim.tbl_deep_extend("force", default_start_task_job_opts, opts or {})

	local command = "task " .. task

	local buf = create_task_buffer()
	vim.api.nvim_command("split")
	vim.api.nvim_win_set_buf(0, buf)

	if opts.notify then
		opts.notify("starting " .. task .. " task", vim.log.INFO)
	end

	vim.fn.jobstart(command, {
		stdout_buffered = false,
		on_stdout = function(_, data)
			if data then
				vim.schedule(function()
					if not vim.api.nvim_buf_is_valid(buf) then
						return
					end

					vim.api.nvim_set_option_value("modifiable", true, {
						buf = buf,
					})
					vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
					vim.api.nvim_set_option_value("modifiable", false, {
						buf = buf,
					})

					vim.api.nvim_win_set_cursor(0, {
						vim.api.nvim_buf_line_count(buf),
						0,
					})
				end)
			end
		end,
		on_exit = function()
			if opts.on_finished then
				opts.on_finished()
			end

			if opts.notify then
				opts.notify(task .. " task finished", vim.log.INFO)
			end
		end,
	})
end

return M
