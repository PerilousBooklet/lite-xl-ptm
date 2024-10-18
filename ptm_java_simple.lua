-- mod-version:3
local ptm = require 'plugins.ptm'

local file0 = [[
# Simple Java Project

...

]]

local file1 = [[
#!/bin/bash

# Compile Main.java into Main.class
javac Main.java

# Create .jar archive from Main.Class as indicated by Manifest.txt
jar -cfm Main.jar Manifest.txt Main.class

# Run .jar executable archive
java -jar Main.jar
]]

local file2 = [[
public class Main {
  public static void main(string[] args) {
    System.out.println("Hello World!")
  }
}
]]

local file3 = [[
Main-Class: Main

]]

ptm.add_template {
  name = "java-simple",
  desc = "A single-file template for Java.",
  files = {
    ["README.md"] = {
      content = file0,
      path = ""
    },
    ["build.sh"] = {
      content = file1,
      path = ""
    },
    ["Main.java"] = {
      content = file2,
      path = ""
    },
    ["Manifest.txt"] = {
      content = file3,
      path = ""
    },
  },
  dirs = {
    "bin",
    "lib"
  },
  ext_libs = {},
  lsp_config_files = {},
  commands = {
    { "chmod", "+x", "build.sh" }
  }
}
