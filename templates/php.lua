-- mod-version:3
local ptm = require 'plugins.ptm'

-- Templates:
-- 1. PHP, Simple Webapp

-- PHP, Simple Webapp
local file1 = [[
#!/bin/bash
cd "./src" || exit
composer require erusev/parsedown
]]

local file2 = [[
#!/bin/bash
php --server localhost:2345 --docroot ./src/
]]

local indexhtml = [[
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="generator" content="Webapp"/>
    <!-- Reference to main page -->
    <meta http-equiv="Refresh" content="0; url='/pages/index.php'" />
    <title></title>
  </head>
  <body>
    <p>&nbsp;</p>
  </body>
</html>
]]

local indexphp = [[
<?php>
  
</?php>
]]

ptm.add_template() {
  name = "php-simple-webapp",
  desc = "A local self-hosted webapp.",
  files = {
    ["setup.sh"] = {
      path = "",
      content = file1
    },
    ["run.sh"] = {
      path = "",
      content = file2
    },
    ["index.html"] = {
      path = "src",
      content = indexhtml
    },
    ["index.php"] = {
      path = "src" .. "/" .. "pages",
      content = indexphp
    },
  },
  dirs = {
    "src",
    "src" .. "/" .. "assets",
    "src" .. "/" .. "components",
    "src" .. "/" .. "functions",
    "src" .. "/" .. "pages",
    "src" .. "/" .. "style",
  },
  ext_libs = {},
  lsp_config_files = {},
  commands = {
    { "chmod", "+x", "setup.sh" },
    { "chmod", "+x", "run.sh" }
  }
}
