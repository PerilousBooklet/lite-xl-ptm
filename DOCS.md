# Documentation

`ptm` can generate folder/file structures for single files and complex project templates.

Single-file templates follow this convention: `(single)project_template_name`.

Complex project templates do not require any name prefix.

## Table of Contents

1. [Functions](#functions)
2. [Data Storage](#data-storage)

## Functions

TODO

## Data Storage

Example module:

`example.lua`

```lua
-- mod-version:3
local ptm = require 'plugins.ptm'

local file1 = "SOMETHING something"

local file2 = [[
SOMETHING
SOMETHING
SOMETHING
]]

ptm.add_template() {
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
    ".dirr",
    ".dirr" .. "/" .. ".dirrr"
  },
  ext_libs = {
    {
      url = "https://github.com/FabricMC/fabric-example-mod/archive/refs/heads/1.21.zip",
      path = "",
      filename = "1.21.zip"
    }
  },
  lsp_config_files = {
    [".something.cfg"] = {
      path = ".dirr" .. "/" .. ".dirrr",
      content = file2
    }
  },
  -- WIP: insert dependencies into build tools' config files (?)
  dependencies = {
    {
      url = "",
      path = "",
      filename = ""
    }
  },
  commands = {
    { "touch", "example.txt" }
  }
}
```
