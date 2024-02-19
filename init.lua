-- mod-version:3
local core = require "core"
local command = require "core.command"
local config = require "core.config"
local keymap = require "core.keymap"

-- Configuration parameters
-- TODO: implement a way to add template files from the user's init.lua
config.plugins.ptm = {}

-- Templates
--require("./templates/cpp_simple")

-- Constants
local wd = system.absolute_path(".") -- Get absolute path of current working directory
local mlstring = [[
#!/bin/bash
echo "It works!"
]]

-- Template generation
local function template_generation(dir)	
	-- Create directories
	-- TODO: automate directory creation
	system.mkdir(wd .. "/" .. dir)
  
	-- Create files
	-- TODO: automate file creation
  local file = "abcd.sh"
  local f = io.open(wd .. "/" .. dir .. "/" .. file, "w")
  f:write(build)
  f:close()
end

-- Template selection
local template_selection = function(t, title)
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

-- Main function
local project_template_manager = function()
  -- Get input text for template name
  core.command_view:enter("Choose template", {
    submit = function(text)
      -- Get input text for project folder title
      core.command_view:enter("Choose project title", {
        submit = function(title)
          -- Check if folder already exists
          if system.get_file_info(wd .. title) == nil then
            -- Submit chosen template for selection
            template_selection(text, title)
          else
            print("WARNING: a folder with this title already exists!")
          end
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
