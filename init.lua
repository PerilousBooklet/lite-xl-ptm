-- mod-version:3
local core = require "core"
local command = require "core.command"
local config = require "core.config"
local keymap = require "core.keymap"

-- Configuration parameters
-- TODO: implement a way to add template files from the user's init.lua
config.plugins.ptm = {}

-- Constants
local mlstring = [[
#!/bin/bash
echo "It works!"
]]

-- Template generation
-- TODO: formal docs
local function template_generation(dir)
  local wd = system.absolute_path(".") -- Get absolute path of current working directory
	
	-- Create directories
	-- TODO: automate directory creation
	system.mkdir(wd .. "/" .. dir)
  
	-- Create files
	-- TODO: automate file creation
	-- TODO: add platform-specific exec permission assignments
  local file = "abcd.sh"
  local f = io.open(wd .. "/" .. dir .. "/" .. file, "w")
  f:write(mlstring)
  f:close()
  print("Template generation works!")

  -- Run commands
  -- ?
end

-- Template selection
-- TODO: formal docs
local template_selection = function(t, title)
	-- Check if directory already exists
	local wd = system.absolute_path(".") -- Get absolute path of current working directory
	local fi = system.get_file_info(wd .. "/" .. title)
	if fi == nil then
    print("Directory already exists!")
	else
    -- Switch-case selection implementation
    local switch = function(t)
      local case = {
      ["cpp_simple"] = function()
        -- TODO: get files table
        -- TODO: get files table entry number
        -- Create template from template description file located in ./templates
        template_generation(title)
        print("Template selection works")
      end,
      ["java_simple"] = function()
        print(t)
      end,
      ["pkgbuild_simple"] = function()
        print(t)
      end,
      default = function()
        -- TODO: spawn warning in status view
        print("WARNING: the input didn't match any of the predefined templates!")
      end
      }
      if case[t] then
        case[t]()
      else
        case["default"]()
      end
    end
    switch(t)
  end
end

-- Main function
local project_template_manager = function()
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
    -- Suggestions for template names
    suggest = function()
    	-- TODO: return suggestions as names of files contained in ./templates folder
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
