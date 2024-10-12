-- mod-version:3
local ptm = require 'plugins.ptm'

local file1 = [[
#!/bin/bash
export PATH="/usr/lib/jvm/java-17-openjdk/bin/:$PATH"
./gradlew runClient
]]

local file2 = [[
#!/bin/bash
export PATH="/usr/lib/jvm/java-17-openjdk/bin/:$PATH"
./gradlew build
]]

ptm.add_template {
  name = "minecraft-forge",
  desc = "Template for the latest Minecraft Forge mod development kit.",
  files = {
    ["run.sh"] = {
      path = "",
      content = file1
    },
    ["build.sh"] = {
      path = "",
      content = file2
    },
  },
  dirs = {
    ".ext_libs"
  },
  ext_libs = {
    ["mdk"] = {
      file = "https://maven.minecraftforge.net/net/minecraftforge/forge/1.20.1-47.3.10/forge-1.20.1-47.3.10-mdk.zip",
      path = ""
    }
  },
  commands = {
    { "unzip", "forge-1.20.1-47.3.10-mdk.zip", "-d", "src" }
  }
}
