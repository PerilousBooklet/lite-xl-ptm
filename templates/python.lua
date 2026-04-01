-- mod-version:3
local ptm = require 'plugins.ptm'

local setup = [[
#!/bin/bash
python -v -m venv .venv
source .venv/bin/activate
pip install ?
]]

local run = [[
#!/bin/bash
source .venv/bin/activate
python main.py
]]

local main = [[
print("Hello there!")
]]

ptm.add_template {
  name = "python",
  desc = "",
  files = {
    ["setup.sh"] = {
      content = setup,
      path = ""
    },
    ["run.sh"] = {
      content = run,
      path = ""
    },
    ["main.py"] = {
      content = "main.py",
      path = ""
    },
    dirs = {},
    ext_libs = {},
    lsp_config_files = {},
    commands = {
      {"chmod", "+x", "setup.sh"},
      {"chmod", "+x", "run.sh"}
    }
  }
}
