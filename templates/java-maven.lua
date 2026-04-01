-- mod-version:3
local ptm = require 'plugins.ptm'

local lite_project = [[
local core = require "core"
local config = require "core.config"

table.insert(config.ignore_files, "^%.jtls$")
table.insert(config.ignore_files, "./*/.jdtls/")
table.insert(config.ignore_files, "src/target/")
]]

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
