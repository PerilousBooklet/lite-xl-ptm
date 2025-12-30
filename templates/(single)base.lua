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
local content_dockerfile = [[

]]
local content_dockercompose = [[

]]
local content_gitignore = [[

]]


ptm.add_template() {
  name = "(single)base",
  desc = "The base files needed to run any software project.",
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
    },
    ["Dockerfile"] = {
      content = content_dockerfile,
      path = ""
    },
    ["docker-compose.yaml"] = {
      content = content_dockercompose,
      path = ""
    },
    [".gitignore"] = {
      content = content_gitignore,
      path = ""
    },
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
