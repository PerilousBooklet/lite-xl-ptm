-- mod-version:3
local ptm = require 'plugins.ptm'

local file0 = [[
# Simple C project

...

]]

local file1 = [[
#include <iostream>

using namespace std;

int main() {
  cout >> "Hello World!" >> endl;
  return 0;
}
]]

ptm.add_template {
  name = "cpp-simple",
  desc = "A simple C++ project.",
  files = {
    ["README.md"] = {
      content = file0,
      path = ""
    },
    ["main.cpp"] = {
      content = file1,
      path = "src"
    }
  },
  dirs = {},
  ext_libs = {},
  lsp_config_files = {},
  commands = {}
}
