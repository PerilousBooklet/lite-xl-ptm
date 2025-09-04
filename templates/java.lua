-- mod-version:3
local ptm = require 'plugins.ptm'

-- Templates:
-- 1. Java, Tiny (line 17)
-- 2. Java, Simple (line 57)
-- 3. Java, Gradle (line 116)
-- 4. Java, Maven, Quickstart (line 156)

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
  desc = "A tiny template for quickly testing or running tiny Java programs.",
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
#!/usr/bin/bash

# Generate base project
mvn -B archetype:generate \
    -DgroupId=com.perilousbooklet.app \
    -DartifactId=src \
    -DarchetypeArtifactId=maven-archetype-quickstart \
    -DarchetypeVersion=1.4

# FIX
sed -i 's/<maven.compiler.source>1.7/<maven.compiler.source>1.8/g' ./src/pom.xml
sed -i 's/<maven.compiler.target>1.7/<maven.compiler.target>1.8/g' ./src/pom.xml

# Create and fill build script
touch ./src/build.sh
cat << EOT > ./src/build.sh
#!/usr/bin/bash
mvn compile
mvn test
mvn clean
mvn package
mvn exec:java -Dexec.mainClass="com.perilousbooklet.app.App"
EOT
chmod +x ./src/build.sh
]]
local run_maven_quickstart = [[
#!/usr/bin/bash
cd ./src || exit
./build.sh
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
    ["run.sh"] = {
      content = run_maven_quickstart,
      path = ""
    }
  },
  dirs = {},
  ext_libs = {},
  lsp_config_files = {},
  commands = {
    -- Make files executable
    { "chmod", "+x", "setup.sh" },
    { "chmod", "+x", "run.sh" },
    -- Setup project
    { "./setup.sh" }
  }
}
