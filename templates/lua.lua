-- mod-version:3
local ptm = require 'plugins.ptm'

local setup = [[
#!/bin/bash

# TO INSTALL A LUA MODULE
# luarocks install --local --tree=.luarocks module_name

# TO REMOVE A LUA MODULE
# luarocks remove --local --tree=.luarocks module_name

# TO SEARCH FOR A LUA MODULE
# luarocks search module_name

# TO LIST ALL LUA MODULES (USE WITH GREP)
# luarocks search --all

luarocks install --local --tree=.luarocks luasocket
luarocks install --local --tree=.luarocks luasec
luarocks install --local --tree=.luarocks http
luarocks install --local --tree=.luarocks dkjson
]]

local run = [[
#!/bin/bash
export LUA_PATH="$(pwd)/.luarocks/share/lua/5.4/?.lua"
export LUA_CPATH="$(pwd)/.luarocks/lib/lua/5.4/?.so"
# luarocks path
lua main.lua
]]

local main = [[
print("Hello there!")
]]

ptm.add_template() {
  name = "lua-tiny",
  desc = "A tiny template for quickly testing or running tiny Lua programs.",
  files = {
    ["setup.sh"] = {
      content = setup,
      path = ""
    },
    ["run.sh"] = {
      content = run,
      path = ""
    },
    ["main.lua"] = {
      content = main,
      path = ""
    }
  },
  dirs = {},
  ext_libs = {},
  lsp_config_files = {},
  commands = {
    { "chmod", "+x", "setup.sh" },
    { "chmod", "+x", "run.sh" }
  }
}
