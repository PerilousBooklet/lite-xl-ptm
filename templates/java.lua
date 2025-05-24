-- mod-version:3
local ptm = require 'plugins.ptm'

-- This module installs 4 templates:
-- 1. Java, Tiny (line 17)
-- 2. Java, Simple (line 45)
-- 3. Java, Gradle (line 104)
-- 4. Java, Maven, Quickstart (line 144)

local readme = [[
# Java Project

...

]]

-- Java, Tiny
local run_tiny = [[
#!/bin/bash
javac -d bin *.java
java -cp bin Main
rm -v bin/*
]]

local java_main_tiny = [[
public class Main {
  
  public static void main(String[] args) {
    System.out.println("Hello there.");
  }
}
]]

ptm.add_template() {
  name = "java-tiny",
  desc = "A tiny template for quick testing or running tiny programs.",
  files = {
    ["run.sh"] = {
      content = run_tiny,
      path = ""
    },
    ["Main.java"] = {
      content = java_main_tiny,
      path = ""
    }
  },
  dirs = {
    "bin"
  },
  ext_libs = {},
  lsp_config_files = {},
  commands = {
    { "chmod", "+x", "run.sh" }
  }
}

-- Java, Simple
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
#!/bin/bash

AUTHOR=""
PROJECT_NAME=""

mvn -B archetype:generate \
    -DgroupId=com.$AUTHOR.$PROJECT_NAME \
    -DartifactId=$PROJECT_NAME \
    -DarchetypeArtifactId=maven-archetype-quickstart \
    -DarchetypeVersion=1.4

sed -i 's/<maven.compiler.source>1.7/<maven.compiler.source>1.8/g' ./$PROJECT_NAME/pom.xml
sed -i 's/<maven.compiler.target>1.7/<maven.compiler.target>1.8/g' ./$PROJECT_NAME/pom.xml

sed -i "s/mycompany/$AUTHOR/g" ./build.sh
sed -i "s/app/$PROJECT_NAME/g" ./build.sh

cp -v ./build.sh ./$PROJECT_NAME/build.sh
]]

local build_maven_quickstart = [[
#!/bin/bash
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
      content = build_maven_quickstart,
      path = ""
    }
  },
  dirs = {},
  ext_libs = {},
  lsp_config_files = {},
  commands = {
    -- Make files executable
    { "chmod", "+x", "setup.sh" },
    { "chmod", "+x", "build.sh" },
    -- Setup project
    -- { "./setup.sh" }
  }
}
