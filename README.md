# taskfile.nvim

Neovim plugin for working w/ [Taskfiles](https://taskfile.dev/)

## Installation

<details>
  <summary>Lazy</summary>

  ```lua
  {
    's0cks/taskfile.nvim',
    version = '*',
    dependencies = {
      'folke/snacks.nvim',
    },
    opts = {},
  }
  ```

</details>

### Dependencies

- [Snacks](https://github.com/folke/snacks.nvim)
- [taskfile-language-server](https://github.com/s0cks/taskfile-language-server)

## Task Picker

The task picker allows you to fuzzy-find a task and run it using Snacks.

```lua
require('taskfile.picker').task_picker()
```

<details>
  <summary>Example</summary>
  [![asciicast](https://asciinema.org/a/fefth2yu4lu9SdvWK5to6dlu2.svg)](https://asciinema.org/a/fefth2yu4lu9SdvWK5to6dlu2)
</details>
