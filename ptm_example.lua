-- mod-version:3
local ptm = require 'plugins.ptm'

local file1 = "something something"

local file2 = "some config options"

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
  commands = {
    { "echo", "something something" }
  },
  ext_libs = {
    ["https://christitus.com/archtitus"] = {
      dir = ".ext_libs"
    }
  },
  lsp_config_files = {
    [".something.cfg"] = {
      path = ".dirr",
      content = file2
    }
  },
  message = {
    header = "This is a brief introduction about this example project template.",
    content = message
  }
}
