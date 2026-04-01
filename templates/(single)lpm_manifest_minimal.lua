-- mod-version:3
local ptm = require 'plugins.ptm'

-- Reference Docs
-- https://github.com/lite-xl/lite-xl-plugin-manager/blob/master/SPEC.md#example-file

local content = [[
{
  "addons": [
    {
      "id": "",
      "mod_version": "3",
      "version": "0.0.1",
      "description": "",
      "path": ".",
      "dependencies": {}
    }
  ]
}
]]

ptm.add_template() {
  name = "(single)lpm-manifest-minimal",
  desc = "A minimal lpm manifest for Lite XL plugins.",
  files = {
    ["manifest.json"] = {
      content = content,
      path = ""
    }
  },
  dirs = {},
  ext_libs = {},
  lsp_config_files = {},
  commands = {}
}
