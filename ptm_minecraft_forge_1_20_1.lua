-- mod-version:3
local ptm = require 'plugins.ptm'

local mdk = "https://maven.minecraftforge.net/net/minecraftforge/forge/1.20.1-47.3.10/forge-1.20.1-47.3.10-mdk.zip"

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

local message = [[

]]

ptm.add_template {
  name = "minecraft-forge-1.20.1",
  desc = "Template for the latest Minecraft Forge 1.20.1 mod development kit.",
  ext_libs = {
    "/home/raffaele/.gradle/caches/modules-2/files-2.1/" -- WIP: path is incomplete
  },
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
  dependencies = {
    ["mdk"] = {
      file = mdk,
      path = ""
    }
  },
  commands = {
    { "unzip", mdk, "-d", "src" },
  },
  message = {
    header = "brief introduction",
    content = message
  }
}
