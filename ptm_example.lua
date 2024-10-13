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
  ext_libs = {
    -- ["localtube"] = {
    --   file = "https://github.com/PerilousBooklet/localtube/archive/refs/heads/main.zip",
    --   dir = ".ext_libs"
    -- }
  },
  lsp_config_files = {
    [".something.cfg"] = {
      path = ".dirr",
      content = file2
    }
  },
  commands = {
    { "alacritty", "-e", "touch", "example.txt" },
    -- { "unzip", "main.zip", "-d", "localtube" }
  },
  message = {
    header = "This is a brief introduction about this example project template.",
    content = message
  }
}
