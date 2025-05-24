-- mod-version:3
local ptm = require 'plugins.ptm'

-- Template Reference
-- https://plantuml.com/

-- This module installs several templates:
-- 1. PlantUML, UML diagram (sequence, usecase, class, activity, component, statemachine, object, deployment, timing, network, archimate)
-- 2. PlantUML, ER Diagram
-- 3. PlantUML, RegEx
-- 4. PlantUML, Wirefrane
-- 5. PlantUML, Gantt
-- 6. PlantUML, Chronology
-- 7. PlantUML, Mindmap
-- 8. PlantUML, WBS
-- 9. PlantUML, EBNF
-- 10. PlantUML, JSON
-- 11. PlantUML, YAML

local file_run = [[
#!/bin/bash
plantuml -tpng main.puml
xdg-open main.png
]]

-- PlantUML, UML Diagram
local file_uml = [[
@startuml
!theme mars
skinparam dpi 200

@enduml
]]

ptm.add_template() {
  name = "plantuml-uml-diagram",
  desc = "A basic template for PlantUML UML diagrams.",
  files = {
    ["run.sh"] = {
      path = "",
      content = file_run
    },
    ["main.puml"] = {
      path = "",
      content = file_uml
    }
  },
  dirs = {},
  ext_libs = {},
  lsp_config_files = {},
  commands = {
    { "chmod", "+x", "run.sh" }
  }
}

-- PlantUML, ER Diagram
local file_er = [[
@stratchen
!theme plain
skinparam dpi 200

@endchen
]]

ptm.add_template() {
  name = "plantuml-er-diagram",
  desc = "A basic template for PlantUML ER diagrams.",
  files = {
    ["run.sh"] = {
      path = "",
      content = file_run
    },
    ["main.puml"] = {
      path = "",
      content = file_er
    }
  },
  dirs = {},
  ext_libs = {},
  lsp_config_files = {},
  commands = {
    { "chmod", "+x", "run.sh" }
  }
}

-- TODO: PlantUML, RegEx

-- TODO: PlantUML, Wirefrane

-- TODO: PlantUML, Gantt

-- TODO: PlantUML, Chronology

-- TODO: PlantUML, Mindmap

-- TODO: PlantUML, WBS

-- TODO: PlantUML, EBNF

-- TODO: PlantUML, JSON

-- TODO: PlantUML, YAML

