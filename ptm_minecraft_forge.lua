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

-- WIP: list the remaining urls
local mdks = {
  -- 1.20.1
  {
    file = "https://maven.minecraftforge.net/net/minecraftforge/forge/1.20.1-47.3.10/forge-1.20.1-47.3.10-mdk.zip",
    jre_ver = "17",
  },
  -- 1.19.2
  {
    file = "https://maven.minecraftforge.net/net/minecraftforge/forge/1.19.2-43.4.4/forge-1.19.2-43.4.4-mdk.zip",
    jre_ver = "17",
  },
  -- 1.18.2
  {
    file = "https://maven.minecraftforge.net/net/minecraftforge/forge/1.18.2-40.2.21/forge-1.18.2-40.2.21-mdk.zip",
    jre_ver = "17",
  },
  -- 1.16.5
  {
    file = "https://maven.minecraftforge.net/net/minecraftforge/forge/1.16.5-36.2.42/forge-1.16.5-36.2.42-mdk.zip",
    jre_ver = "8",
  },
  -- 1.12.2
  {
    file = "https://maven.minecraftforge.net/net/minecraftforge/forge/1.12.2-14.23.5.2859/forge-1.12.2-14.23.5.2859-mdk.zip",
    jre_ver = "8",
  },
  -- 1.10.2
  {
    file = "https://maven.minecraftforge.net/net/minecraftforge/forge/1.10.2-12.18.3.2511/forge-1.10.2-12.18.3.2511-mdk.zip",
    jre_ver = "8",
  },
  -- 1.7.10
  {
    file = "https://maven.minecraftforge.net/net/minecraftforge/forge/1.7.10-10.13.4.1614-1.7.10/forge-1.7.10-10.13.4.1614-1.7.10-src.zip",
    jre_ver = "8",
  },
}

-- Filling...
for _, v in pairs(mdks) do
  -- Extract Minecraft and Forge versions from URL
	local minecraft_ver_temp = string.match(v.file, "%/%d+%.%d+%.%d+%.?%d*")
  local forge_ver_temp = string.match(v.file, "%-%d+%.%d+%.%d+%.?%d*")
  local minecraft_ver = string.gsub(minecraft_ver_temp, "/", "")
  local forge_ver = string.gsub(forge_ver_temp, "-", "")
  -- Assign JDK version
  local run_script = string.gsub(file1, "sss", v.jre_ver)
  local build_script = string.gsub(file2, "sss", v.jre_ver)
  -- Add template to templates table
  ptm.add_template {
    name = string.format("minecraft-forge-%s-%s", minecraft_ver, forge_ver),
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
      { "unzip", string.gsub(string.match(v.file, "%/.+%.zip"), "/", ""), "-d", "src" }
    }
  }
end
