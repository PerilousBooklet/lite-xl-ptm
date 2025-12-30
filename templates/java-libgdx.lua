-- mod-version:3
local ptm = require 'plugins.ptm'


local content_setup = [[

]]
local content_build = [[

]]
local content_run = [[

]]
local content_debug = [[

]]
local content_profile = [[

]]


ptm.add_template() {
  name = "java-libgdx",
  desc = "...",
  files = {
    ["setup.sh"] = {
      content = content_setup,
      path = ""
    },
    ["build.sh"] = {
      content = content_build,
      path = ""
    },
    ["run.sh"] = {
      content = content_run,
      path = ""
    },
    ["debug.sh"] = {
      content = content_debug,
      path = ""
    },
    ["profile.sh"] = {
      content = content_debug,
      path = ""
    }
  },
  dirs = {},
  ext_libs = {},
  lsp_config_files = {},
  commands = {
    { "chmod", "+x", "setup.sh" },
    { "chmod", "+x", "build.sh" },
    { "chmod", "+x", "run.sh" },
    { "chmod", "+x", "debug.sh" },
    { "chmod", "+x", "profile.sh" }
  }
}
