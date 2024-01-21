-- mod-version:3
local core = require "core"
local command = require "core.command"
local config = require "core.config"
local keymap = require "core.keymap"

-- Configuration parameters
-- TODO: implement a way to add template files from the user's init.lua
config.plugins.ptm = {}

-- Import template description files
local templates = require "templates.cpp_simple"

-- TODO: formal docs
-- Template generation
local function template_generation(title)
	local dir = title
	local wd = system.absolute_path(".") -- Get absolute path of current working directory
	
	-- TODO: check if there is a directory with the same name as the one from user input; if there is, refuse further instructions
	
	-- Create project directory
	system.mkdir(wd .. "/" .. dir)
  
  -- TODO: get and assign filename from template file
	-- TODO: get and assign multi-line strings from template file
  -- TODO: get files list (each file is assigned a string of text to contain)
  -- TODO: write iterator to create and fill files
	-- TODO: write to the files the contents of the multi-line string tables
	-- TODO: create additional directories inside template directory
	-- TODO: add adamharrison/lite-xl-ide build plugin configuration file
	-- Create files
  local filename = "abcd.sh"
	local file = io.open(wd .. "/" .. dir .. "/" .. filename, "w")
  -- Write file contents
  file:write(cpp_simple.build)
  file:close()
end

-- TODO: formal docs
-- Template selection
local template_selection = function(t, title)
	-- Switch-case function implementation
  local switch = function(t)
    local case = {
    -- C++ simple
    ["cpp_simple"] = function()
      -- TODO: get files table
      -- TODO: get files table entry number
      -- Create template from template description file located in ./templates
      print(title)
      template_generation(title)
    end,
    -- Java simple
    ["java-simple"] = function()
      print("java")
    end,
    -- Arch Linux's PKGBUILD
    ["pkgbuild-simple"] = function()
      print(t)
    end,
    -- Default case
    default = function()
      -- TODO: spawn warning in status view
      print("WARNING: the input didn't match any of the predefined templates!")
    end,
    }
    -- Selection logic
    if case[t] then
      case[t]()
    else
      case["default"]()
    end
  end
  switch(t)
end

-- ?
local project_template_manager = function()
  -- TODO: Implement template name suggestions list above command view
  -- Get input text for template name
  core.command_view:enter("Choose template", {
    submit = function(text)
      -- Get input text for project folder title
      core.command_view:enter("Choose project title", {
        submit = function(title)
          -- Submit chosen template for selection
          template_selection(text, title)
        end
      })
    end,
    suggest = function()
    	-- TODO: return suggestions as names of files inside ./templates folder
      -- TODO: filter suggestions matching already entered characters (es. common.fuzzy_match)
    	--return ?
    end
  })
end

-- Commands
command.add(nil, {
  ["ptm:choose-template"] = function ()
    project_template_manager()
  end
})

-- Key bindings
keymap.add {
  ["alt+p"] = "ptm:choose-template"
}
