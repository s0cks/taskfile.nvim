local M = {}

---@class taskfile.runner.RunOpts : snacks.terminal.Opts
---@field exec? string The task executable path
local default_run_opts = {
	exec = "task",
	notify = true,
}

---@param task string The task to run
---@param opts? taskfile.runner.RunOpts
function M.run(task, opts)
	opts = vim.tbl_deep_extend("force", default_run_opts, opts or {})

	if opts.notify then
		vim.notify("starting task " .. task, vim.log.levels.INFO)
	end

	Snacks.terminal.open(opts.exec .. " " .. task, --[[@as snacks.terminal.Opts ]] {
		auto_close = false,
		interactive = true,
	})
end

return M
