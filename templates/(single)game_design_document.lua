-- mod-version:3
local ptm = require 'plugins.ptm'

local content = [[

]]

ptm.add_template() {
  name = "(single)project-plan",
  desc = "A professional, minimal project plan.",
  files = {
    ["PLAN.md"] = {
      content = content,
      path = ""
    }
  },
  dirs = {},
  dependencies = {},
  lsp_config_files = {},
  commands = {}
}
