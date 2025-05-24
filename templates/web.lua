-- mod-version:3
local ptm = require 'plugins.ptm'

-- This module installs ? templates:
-- 1. Tiny website (line 8)
-- 2. Simple static website (line 43)

-- Tiny website
local run_tiny = [[
#!/bin/bash
firefox index.html
]]

ptm.add_template() {
  name = "web-tiny",
  desc = "A tiny static website template made for exercising.",
  files = {
    ["run.sh"] = {
      content = run_tiny,
      path = ""
    },
    ["index.html"] = {
      content = [[]],
      path = ""
    },
    ["style.css"] = {
      content = [[]],
      path = ""
    },
    ["lib.js"] = {
      content = [[]],
      path = ""
    }
  },
  dirs = {},
  ext_libs = {},
  lsp_config_files = {},
  commands = {
    { "chmod", "+x", "run.sh" }
  }
}

-- Simple static website
local run_ssw = [[
#!/bin/bash
firefox index.html
]]

ptm.add_template() {
  name = "web-simple-static-website",
  desc = "A simple static website written in HTML, CSS and a touch of Javascript.",
  files = {
    ["run.sh"] = {
      content = run_ssw,
      path = ""
    },
    ["index.html"] = {
      content = [[]],
      path = ""
    },
    ["style.css"] = {
      content = [[]],
      path = "/" .. "style"
    }
  },
  dirs = {
    "assets",
    "components",
    "lib",
    "pages",
    "style"
  },
  ext_libs = {},
  lsp_config_files = {},
  commands = {
    { "chmod", "+x", "run.sh" }
  }
}
