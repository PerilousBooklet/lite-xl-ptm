-- mod-version:3
local ptm = require 'plugins.ptm'

-- This module installs 1 template:
-- 1. Python, Tiny (line 7)

-- Python, Tiny
local setup_tiny = [[
#!/bin/bash
python -v -m venv .venv
source .venv/bin/activate
pip install ?
]]
local run_tiny = [[
#!/bin/bash
source .venv/bin/activate
python main.py
]]
local python_main_tiny = [[
print("Hello there!")
]]

ptm.add_template {
  name = "python-tiny",
  desc = "", 
  files = {
    ["setup.sh"] = {
      content = setup_tiny,
      path = ""
    },
    ["run.sh"] = {
      content = run_tiny,
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
