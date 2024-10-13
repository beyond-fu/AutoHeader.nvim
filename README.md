# This is a modified version of [42-header.nvim](https://github.com/Diogo-ss/42-header.nvim.git) plugin

## ✨ Features

- Auto update on save (optional)
- Supports `commentstring`
- Supports Git
- Supports symmetry or asymmetry comment with no redundant spaces inserted in case the formatter doesn't work.
- Command: `AutoHeader`

## 🚀 Showcase

`C` file:
![example_c](https://github.com/beyond-fu/AutoHeader.nvim/blob/main/img/example_c.png)

`Systemverilog` file:
![example_sv](https://github.com/beyond-fu/AutoHeader.nvim/blob/main/img/example_sv.png)

## 🎈 Setup

<details>
  <summary>💤 Lazy.nvim</summary>

```lua
{
    "beyond-fu/AutoHeader.nvim",
    event = "BufRead",
    opts = {},
}
```

</details>

## ⚙ Options(default)

```lua
{
  length = 80,            -- max length for each line(including commentstring)
  margin = 5,             -- margin length(including commentstring)
  default_map = true,     -- default keymap: F4
  auto_update = true,     -- if auto-update `update_time` when saving
  user = "username",      -- default username
  mail = "your@mail.com", -- default email
  copyright = false,      -- copyright message
  company = nil,          -- company message when copyright is on, should be a string or nil
  description = false,    -- depcription message
  license = false,        -- license message
  license_type = nil,     -- license type when license is on, should be a string or nil
  --- Git support
  git = {
    enabled = false,
    bin = "git",         -- path of `git` bin
    user_global = true,  -- use global user.name, otherwise use local user.name.
    email_global = true, -- use global user.email, otherwise use local user.email.
  },
}
```

## 🌐 User and Email

`user` and `email` can also be defined using vim global variables, this is the first priority.

```lua
vim.g.user = "username"
vim.g.mail = "your@mail.com"
```
