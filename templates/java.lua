-- mod-version:3
local ptm = require 'plugins.ptm'

-- This module installs 3 templates:
-- 1. Java, Simple (line 9)
-- 2. Java, Gradle (line 75)
-- 3. Java, Maven, Quickstart (line 116)

-- Java, Simple
local readme = [[
# Java Project

...

]]

local build_simple = [[
#!/bin/bash

# Compile Main.java into Main.class
javac Main.java

# Create .jar archive from Main.Class as indicated by Manifest.txt
jar -cfm Main.jar Manifest.txt Main.class

# Run .jar executable archive
java -jar Main.jar
]]

local main_simple = [[
public class Main {
  public static void main(string[] args) {
    System.out.println("Hello World!")
  }
}
]]

local manifest_simple = [[
Main-Class: Main

]]

ptm.add_template() {
  name = "java-simple",
  desc = "A single-file template for Java.",
  files = {
    ["README.md"] = {
      content = readme,
      path = ""
    },
    ["build.sh"] = {
      content = build_simple,
      path = ""
    },
    ["Main.java"] = {
      content = main_simple,
      path = ""
    },
    ["Manifest.txt"] = {
      content = manifest_simple,
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

-- Java, Gradle
local build_gradle = [[
#!/usr/bin/bash
./gradlew run
]]

local run_gradle = [[
#!/usr/bin/bash
./gradlew build
]]

ptm.add_template() {
  name = "java-gradle",
  desc = "",
  files = {
    ["README.md"] = {
      content = readme,
      path = ""
    },
    ["build.sh"] = {
      content = build_gradle,
      path = ""
    },
    ["run.sh"] = {
      content = run_gradle,
      path = ""
    }
  },
  dirs = {},
  ext_libs = {},
  lsp_config_files = {},
  commands = {
    -- Setup project
    { "gradle", "init" },
    -- Make files executable
    { "chmod", "+x", "build.sh" },
    { "chmod", "+x", "run.sh" }
  }
}

-- Java, Maven, Quickstart
local setup_maven_quickstart = [[
#!/usr/bin/bash
mvn -B archetype:generate \
    -DgroupId=com.mycompany.app \
    -DartifactId=example \
    -DarchetypeArtifactId=maven-archetype-quickstart \
    -DarchetypeVersion=1.4
# FIX
sed -i 's/<maven.compiler.source>1.7/<maven.compiler.source>1.8/g' ./example/pom.xml
sed -i 's/<maven.compiler.target>1.7/<maven.compiler.target>1.8/g' ./example/pom.xml

cp -v ./build.sh ./example/build.sh
]]

local build_maven = [[
#!/usr/bin/bash
mvn compile
mvn test
mvn package
mvn exec:java -Dexec.mainClass="com.mycompany.app.App"
]]

ptm.add_template() {
  name = "java-maven-quickstart",
  desc = "Maven quickstart template.",
  files = {
    ["README.md"] = {
      content = readme,
      path = ""
    },
    ["setup.sh"] = {
      content = setup_maven_quickstart,
      path = ""
    },
    ["build.sh"] = {
      content = build_maven,
      path = ""
    },
  },
  dirs = {},
  ext_libs = {},
  lsp_config_files = {},
  commands = {
    -- Make files executable
    { "chmod", "+x", "setup.sh" },
    { "chmod", "+x", "build.sh" },
    -- Setup project
    { "./setup.sh" }
  }
}
