# taskfile.nvim

A [Neovim](https://neovim.io/) plugin for working w/ [Taskfiles](https://taskfile.dev/)

![Example](./assets/example.gif)

## Installation

<details>
  <summary>vim.pack</summary>

  > **Requires Neovim v0.12+**

  ```lua
  vim.pack.add({
    --- .....
    {
      source = 's0cks/taskfile.nvim',
      setup = function()
        require('taskfile').setup({
          ---@see lua/taskfile/config.lua
        })
      end
    },
    --- .....
  })
  ```

</details>

<details>
  <summary>Lazy</summary>

  ```lua
  {
    's0cks/taskfile.nvim',
    version = '*',
    dependencies = { },
    opts = {},
  }
  ```

</details>

### Default Config

Here is the default config:

```lua
---@class taskfile.Opts
---@field notify? fun(msg, level, opts) The notify function
{
  notify = vim.notify,
}
```

> See [lua/taskfile/config.lua](./lua/taskfile/config.lua) for an up-to-date version

### Dependencies

- [taskfile-lsp](https://github.com/s0cks/task-lsp) --- A language-server (LSP) for working w/ Taskfiles `Optional / Highly Recommended`

## API

```lua
---@class taskfile.Task
---@field name string The name of the task
---@field desc string The description of the task

---@class taskfile.SelectOpts : vim.ui.select.Opts

---@class taskfile.TaskJobOpts
---@field notify? fun(msg, level, opts) The notify function
---@field on_finished? fun() The callback to invoke when finished
```

### Getting a list of tasks

You can get a list of tasks from the Taskfile:

```lua
local tasks = require('taskfile').list_tasks()
```

---

```lua
--- List the available tasks
---@return taskfile.Task[]
function M.list_tasks() end
```

### Opening a vim.ui.select for a list of tasks

You can open `vim.ui.select` for a list of tasks using:

```lua
local taskfile = require('taskfile')
local tasks = taskfile.list_tasks()
taskfile.select_task(tasks, function(task)
  --- do something
end)
```

---

```lua
--- Open a select prompt for a list of tasks
---@param tasks taskfile.Task[] The tasks to select from
---@param on_choice fun(task: taskfile.Task) The callback when a choice is selected
---@param opts? taskfile.SelectOpts The opts to use
function M.select_task(tasks, on_choice, opts) end
```

### Starting a task job

You can start a job for a task by doing:

```lua
require('taskfile').start_task_job('default')
```

---

```lua
--- Start a job running the task
---@param task string The name of the task to run
---@param opts? taskfile.TaskJobOpts
function M.start_task_job(task, opts) end
```

## Credits

- The [Task](https://taskfile.dev/) team --- For task :heart_hands:

## License

See [LICENSE](/LICENSE)
