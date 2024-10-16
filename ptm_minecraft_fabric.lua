-- mod-version:3
local ptm = require 'plugins.ptm'

local file0 = [[
# Example Mod

...

]]

local file1 = [[
#!/bin/bash
export PATH="/usr/lib/jvm/java-sss-openjdk/bin/:$PATH"
./gradlew runClient
]]

local file2 = [[
#!/bin/bash
export PATH="/usr/lib/jvm/java-sss-openjdk/bin/:$PATH"
./gradlew build
]]

local file3 = [[
#!/bin/bash
export PATH="/usr/lib/jvm/java-sss-openjdk/bin/:$PATH"
./gradlew genSources
]]

local mdks = {
  -- 1.21
  {
    file = "https://github.com/FabricMC/fabric-example-mod/archive/refs/heads/1.21.zip",
    jre_ver = "21",
  },
  -- 1.20
  {
    file = "https://github.com/FabricMC/fabric-example-mod/archive/refs/heads/1.20.zip",
    jre_ver = "17",
  },
  -- 1.19
  {
    file = "https://github.com/FabricMC/fabric-example-mod/archive/refs/heads/1.19.zip",
    jre_ver = "17",
  },
  -- 1.18
  {
    file = "https://github.com/FabricMC/fabric-example-mod/archive/refs/heads/1.18.zip",
    jre_ver = "17",
  },
  -- 1.17
  {
    file = "https://github.com/FabricMC/fabric-example-mod/archive/refs/heads/1.17.zip",
    jre_ver = "17",
  }
}

-- Filling...
for _, v in pairs(mdks) do
  -- Extract Fabric version from URL
  local fabric_ver_temp = string.match(v.file, "%/%d+%.%d+")
  local fabric_ver = string.gsub(fabric_ver_temp, "/", "")
  -- Assign JDK version
  local run_script = string.gsub(file1, "sss", v.jre_ver)
  local build_script = string.gsub(file2, "sss", v.jre_ver)
  local setup_script = string.gsub(file3, "sss", v.jre_ver)
  -- Add template to templates table
  ptm.add_template {
    name = string.format("minecraft-fabric-%s", fabric_ver),
    files = {
      ["README.md"] = {
        path = "",
        content = file0
      },
      ["run.sh"] = {
        path = "",
        content = run_script
      },
      ["build.sh"] = {
        path = "",
        content = build_script
      },
      ["setup.sh"] = {
        path = "",
        content = setup_script
      },
    },
    dirs = {},
    ext_libs = {
      {
        file = v.file,
        path = ""
      }
    },
    lsp_config_files = {},
    commands = {
      -- The archive name is extracted from the URL with string.match and string.gsub
      { "unzip", string.gsub(string.match(v.file, "%/.+%.zip"), "/", ""), "-d", "src" },
      -- WIP: https://fabricmc.net/wiki/tutorial:setup
      { "./setup" }
    }
  }
end
