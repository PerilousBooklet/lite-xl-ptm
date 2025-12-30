-- mod-version:3
local ptm = require 'plugins.ptm'


local init = [[
-- mod-version:3
local core = require "core"
core.log("example")
]]

local content = [[
#!/bin/bash
lpm run --ephemeral ./ example
]]

local manifest = [[
{
  "addons": [
    {
      "id": "example",
      "mod_version": "3",
      "name": "Example plugin.",
      "path": ".",
      "type": "plugin",
      "version": "0.0.1"
    }
  ]
}
]]

ptm.add_template() {
  name = "lite-xl-plugin",
  desc = "The default setup for a Lite XL plugin.",
  files = {
    ["init.lua"] = {
      content = init,
      path = ""
    },
    ["manifest.json"] = {
      content = manifest,
      path = ""
    },
    ["run.sh"] = {
      content = content,
      path = ""
    }
  },
  dirs = {},
  ext_libs = {},
  lsp_config_files = {},
  commands = { "chmod", "+x", "run.sh" }
}
