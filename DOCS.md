# Documentation

## Table of Contents

1. [Functions](#functions)
2. [Data Storage](#data-storage)

## Functions

TODO

## Data Storage

Example module:

`ptm_example.lua`

```lua
-- mod-version:3
local ptm = require 'plugins.ptm'

local file1 = "SOMETHING something"

local file2 = [[
SOMETHING
SOMETHING
SOMETHING
]]

ptm.add_template {
  name = "example",
  desc = "Example template.",
  files = {
    ["setup.sh"] = {
      path = "dir",
      content = file1
    },
    ["build.sh"] = {
      path = "dir",
      content = file1
    },
    ["run.sh"] = {
      path = "dir",
      content = file1
    }
  },
  dirs = {
    ".ext_libs",
    ".dirr"
  },
  ext_libs = {
    ["1.21.zip"] = {
      url = "https://github.com/FabricMC/fabric-example-mod/archive/refs/heads/1.21.zip",
      path = ""
    }
  },
  lsp_config_files = {
    [".something.cfg"] = {
      path = ".dirr",
      content = file2
    }
  },
  commands = {
    { "touch", "example.txt" }
  }
}
```
