-- mod-version:3
local ptm = require 'plugins.ptm'

local lite_project = [[
local core = require "core"
local config = require "core.config"

table.insert(config.ignore_files, "^%.jtls$")
table.insert(config.ignore_files, "./*/.jdtls/")
table.insert(config.ignore_files, "src/target/")
]]

local build_gradle = [[
#!/usr/bin/bash
./gradlew run
]]

local run_gradle = [[
#!/usr/bin/bash
./gradlew build
]]

ptm.add_template() {
  name = "java-gradle",
  desc = "",
  files = {
    ["README.md"] = {
      content = "",
      path = ""
    },
    ["build.sh"] = {
      content = build_gradle,
      path = ""
    },
    ["run.sh"] = {
      content = run_gradle,
      path = ""
    },
    [".lite_project.lua"] = {
      content = lite_project,
      path = ""
    }
  },
  dirs = {},
  ext_libs = {},
  lsp_config_files = {},
  commands = {
    -- Setup project
    { "gradle", "init" },
    -- Make files executable
    { "chmod", "+x", "build.sh" },
    { "chmod", "+x", "run.sh" }
  }
}
