local M = {}

---@param ft string The filetype
---@param filenames table<string> The list of files
local function add_filetype_for_filenames(ft, filenames)
	local filename = {}
	for _, f in ipairs(filenames) do
		filename[f] = ft
	end
	vim.filetype.add({
		filename = filename,
	})
end

---@class taskfile.Config : vim.lsp.Config
local default_config = {
	cmd = {
		"taskfile-language-server",
	},
	filetypes = {
		"yaml.taskfile",
	},
	root_markers = {
		".git",
	},
}

---@param opts? taskfile.Config
M.setup = function(opts)
	opts = vim.tbl_deep_extend("force", default_config, opts)
	add_filetype_for_filenames("yaml.taskfile", {
		"Taskfile.yaml",
		"Taskfile.yml",
	})
	vim.lsp.config("taskfile", {
		cmd = opts.cmd,
		root_markers = opts.root_markers,
		filetypes = opts.filetypes,
		on_attach = function(client, bufnr)
			vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
			vim.notify("taskfile-language-server attached", vim.log.levels.INFO)
			if opts.on_attach then
				opts.on_attach(client, bufnr)
			end
		end,
	})
	vim.lsp.enable("taskfile")
end

return M
