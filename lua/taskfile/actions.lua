local M = {}

---@param opts? taskfile.runner.RunOpts
M.run = function(opts)
	return function(picker, item)
		picker:close()
		if item then
			vim.schedule(function()
				require("taskfile.runner").run(item.value, opts)
			end)
		end
	end
end

return M
