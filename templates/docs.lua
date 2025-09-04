-- mod-version:3
local ptm = require 'plugins.ptm'

-- Templates
-- 1. Base

-- Base
local base_readme = [[
# Title

...

]]
local base_plan = [[
# Plan

...

]]
local base_arch = [[
# Architecture

...

]]

ptm.add_template() {
  name = "docs-base",
  desc = "",
  files = {
    ["README.md"] = base_readme,
    ["PLAN.md"] = base_plan,
    ["ARCH.md"] = base_arch
  },
  dirs = {
    "diagrams",
    "sketches"
  },
  ext_libs = {},
  lsp_config_files = {},
  commands = {}
}
