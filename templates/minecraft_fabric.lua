-- mod-version:3
local ptm = require 'plugins.ptm'

local file0 = [[
# Example Mod

...

]]

local file1 = [[
#!/bin/bash
cd ./src || exit
export PATH="/usr/lib/jvm/java-sss-openjdk/bin/:$PATH"
./gradlew runClient
]]

local file2 = [[
#!/bin/bash
cd ./src || exit
export PATH="/usr/lib/jvm/java-sss-openjdk/bin/:$PATH"
./gradlew build
]]

local file3 = [[
#!/bin/bash
cd ./src || exit
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
    jre_ver = "21",
  },
  -- 1.19
  {
    file = "https://github.com/FabricMC/fabric-example-mod/archive/refs/heads/1.19.zip",
    jre_ver = "21",
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
  ptm.add_template() {
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
        filename = string.format("%s.zip", fabric_ver),
        url = v.file,
        path = ""
      }
    },
    lsp_config_files = {},
    commands = {
      -- Wait until the archive is fully downloaded
      -- FIX: the command table gets run without waiting for wget to finish downloading the deps
      { "sleep 10" },
      -- Setup mod development kit
      { "unzip", string.format("%s.zip", fabric_ver) },
      { "mv", string.format("fabric-example-mod-%s", fabric_ver), "src" },
      { "rm", "-v", string.format("%s.zip", fabric_ver) },
      -- Make scripts executable
      { "chmod", "+x", "run.sh" },
      { "chmod", "+x", "build.sh" },
      { "chmod", "+x", "setup.sh" },
      -- Run setup script
      { "./setup.sh" }
    }
  }
end
