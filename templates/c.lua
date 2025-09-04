-- mod-version:3
local ptm = require 'plugins.ptm'

-- Templates:
-- 1. C, Tiny (line 7)

-- C, Tiny
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
