-- mod-version:3 lite-xl 2.1
local ptm = require 'plugins.ptm'

ptm.add {
  name = "c_basic",
  files = { "main.c", "run.sh" },
  desc = "A very simple C project template.",
  files = {
    ["main.c"] = [[
#include <stdio.h>
int main() {
  printf("Hello there!\nI am learning C.\nAnd it's awesome!\n");
  return 0;
}
]],
    ["run.sh"] = [[
#!/usr/bin/bash
gcc main.c -o ./bin/main
./bin/main
]]
  },
  -- Example: maven commands to build/test/run a project
  commands = {
    ""
  },
  -- Directories to be created
  dirs = {
    "bin",
    "lib"
  }
}
