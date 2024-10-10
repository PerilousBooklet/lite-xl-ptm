-- mod-version:3
local ptm = require 'plugins.ptm'

local file1 = [[
something something
]]

local file2 = [[
some config options
]]

local message = [[
Something something something
something something something
something something something
something something something.
]]

ptm.add_template {
  name = "example",
  desc = "Example template.",
  files = {
    ["run.sh"] = {
      path = ".dir" .. "/" .. "dir",
      content = file1
    }
  },
  dirs = {
    ".dirr"
  },
  commands = {
    { "echo", "something something" }
  },
  ext_libs = {
    "https://christitus.com/archtitus"
  },
  lsp_config_files = {
    [".something.cfg"] = {
      path = "",
      content = file2
    }
  },
  message = {
    header = "This is a brief introduction about this example project template.",
    content = message
  }
}
