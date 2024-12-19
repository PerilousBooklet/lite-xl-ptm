-- mod-version:3
local ptm = require 'plugins.ptm'

local file0 = [[
# Simple C project

...

]]

local file1 = [[
#include <stdio.h>

int main() {
  printf("Hello World!\n")
  return 0;
}
]]

ptm.add_template() {
  name = "c-simple",
  desc = "A simple C project.",
  files = {
    ["README.md"] = {
      content = file0,
      path = ""
    },
    ["main.c"] = {
      content = file1,
      path = "src"
    }
  },
  dirs = {},
  ext_libs = {},
  lsp_config_files = {},
  commands = {}
}
