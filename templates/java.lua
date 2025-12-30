-- mod-version:3
local ptm = require 'plugins.ptm'

-- Templates:
-- 2. Java, Simple, App 
-- 2. Java, Simple, Library
-- 3. Java, Maven, Quickstart
-- 4. Java, Gradle

local lite_project = [[
local core = require "core"
local config = require "core.config"

table.insert(config.ignore_files, "^%.jtls$")
table.insert(config.ignore_files, "./*/.jdtls/")
table.insert(config.ignore_files, "src/target/")
]]


-- Java, Simple, App
-- NOTE: the square brackets in the [[  ]] bash expressions must be excluded with \
-- TODO: add test.sh
-- TODO: add debug.sh
-- TODO: add profile.sh
local run_simple_app = [=[
#!/bin/bash

JAVA_VERSION=25
AUTHOR='PerilousBooklet'
VERSION='0.0.1'
JAR_FILE='app.jar'
RESOURCES=(
  'assets/'
)

# Init
if [[ ! -d ./bin ]]; then
  mkdir -v ./bin
fi
if [[ ! -d ./lib ]]; then
  mkdir -v ./lib
fi

# Create Manifest file
cat << EOT > Manifest.txt
Manifest-Version: $VERSION
Created-By: $AUTHOR
Main-Class: main.Main
EOT

# Generate list of third-party dependencies
DEPS=$(echo $(find ./lib/*.jar | sed -e 's|^./||g'))

# Build source code
/usr/lib/jvm/java-$JAVA_VERSION-openjdk/bin/javac \
  --class-path "$DEPS" \
  -d bin \
  $(find src -name "*.java")

# Update Manifest file with entried for libs and resources
echo -e "Class-Path: $DEPS ${RESOURCES[*]}\n" >> Manifest.txt

# Include resource files
if [[ -d assets ]]; then
  mkdir -vp bin/assets/
  cp -vr assets/* bin/assets/
fi

# Create jar file
if [[ -f $JAR_FILE ]]; then
  jar \
    --verbose \
    --update \
    --file $JAR_FILE \
    --manifest Manifest.txt \
    -C bin \
    .
else
  jar \
    --verbose \
    --create \
    --file $JAR_FILE \
    --manifest Manifest.txt \
    -C bin \
    .
fi

# Run app
/usr/lib/jvm/java-$JAVA_VERSION-openjdk/bin/java -jar $JAR_FILE

# Clean build files
rm -vrf bin/*
rm -v $JAR_FILE
]=]

local main_simple_app = [[
package main;

public class Main {
  
  public static void main(String[] args) {
    System.out.println("Hello World!");
  }
  
}
]]

ptm.add_template() {
  name = "java-simple-app",
  desc = "A simple, from-scratch template for a Java application.",
  files = {
    ["README.md"] = {
      content = "",
      path = ""
    },
    ["run.sh"] = {
      content = run_simple_app,
      path = ""
    },
    ["Main.java"] = {
      content = main_simple_app,
      path = "src" .. "/" .. "main"
    },
    [".lite_project.lua"] = {
      content = lite_project,
      path = ""
    }
  },
  dirs = {
    "src",
    "src" .. "/" .. "main",
    "bin",
    "lib",
    "assets",
    "docs"
  },
  ext_libs = {},
  lsp_config_files = {},
  commands = {
    { "chmod", "+x", "run.sh" }
  }
}

-- Java, Simple, Library
-- NOTE: the square brackets in the [[  ]] bash expressions must be excluded with \
-- TODO: add mock project template to test the library
local run_simple_library = [=[
#!/bin/bash

JAVA_VERSION=25
AUTHOR='PerilousBooklet'
VERSION='0.0.1'
JAR_FILE='lib1.jar'

# Init
if [[ ! -d ./bin ]]; then
  mkdir -v ./bin
fi
if [[ ! -d ./lib ]]; then
  mkdir -v ./lib
fi

# Create Manifest file
cat << EOT > Manifest.txt
Manifest-Version: $VERSION
Created-By: $AUTHOR
EOT

# Generate list of third-party dependencies
DEPS=$(echo $(find ./lib/*.jar | sed -e 's|^./||g'))

# Build source code
/usr/lib/jvm/java-$JAVA_VERSION-openjdk/bin/javac \
  --class-path "$DEPS" \
  -d bin \
  $(find src -name "*.java")

echo -e "Class-Path: $DEPS ${RESOURCES[*]}\n" >> Manifest.txt

# Create jar file
if [[ -f $JAR_FILE ]]; then
  jar \
    --verbose \
    --update \
    --file $JAR_FILE \
    --manifest Manifest.txt \
    -C bin \
    .
else
  jar \
    --verbose \
    --create \
    --file $JAR_FILE \
    --manifest Manifest.txt \
    -C bin \
    .
fi

# Clean build files
rm -vrf bin/*
]=]

ptm.add_template() {
  name = "java-simple-library",
  desc = "A simple, from-scratch template for a Java library.",
  files = {
    ["README.md"] = {
      content = "",
      path = ""
    },
    ["run.sh"] = {
      content = run_simple_library,
      path = ""
    },
    [".lite_project.lua"] = {
      content = lite_project,
      path = ""
    }
  },
  dirs = {
    "src",
    "bin",
    "lib",
    "docs"
  },
  ext_libs = {},
  lsp_config_files = {},
  commands = {
    { "chmod", "+x", "run.sh" }
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
      content = "",
      path = ""
    },
    ["build.sh"] = {
      content = build_gradle,
      path = ""
    },
    ["run.sh"] = {
      content = run_gradle,
      path = ""
    },
    [".lite_project.lua"] = {
      content = lite_project,
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

# Base project
mvn -B archetype:generate \
    -DgroupId=com.mycompany \
    -DartifactId=example \
    -DarchetypeArtifactId=maven-archetype-quickstart \
    -DarchetypeVersion=1.4

# Fix
sed -i 's/<maven.compiler.source>1.7/<maven.compiler.source>1.8/g' ./src/pom.xml
sed -i 's/<maven.compiler.target>1.7/<maven.compiler.target>1.8/g' ./src/pom.xml

# Build script
touch ./src/build.sh
cat << EOT > ./src/build.sh
#!/usr/bin/bash
mvn clean
mvn compile
mvn test
mvn package
mvn exec:java -Dexec.mainClass="com.mycompany.example.App"
EOT
chmod +x ./src/build.sh
]]
-- TODO: see todo at line 199
local run_maven_quickstart = [[
#!/usr/bin/bash
cd ./example || exit
./build.sh
]]

ptm.add_template() {
  name = "java-maven-quickstart",
  desc = "Maven quickstart template.",
  files = {
    ["README.md"] = {
      content = "",
      path = ""
    },
    ["setup.sh"] = {
      -- TODO: replace "example" with replacement tag and use string.gsub to replace it with given project name
      content = setup_maven_quickstart,
      path = ""
    },
    ["run.sh"] = {
      content = run_maven_quickstart,
      path = ""
    },
    [".lite_project.lua"] = {
      content = lite_project,
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
