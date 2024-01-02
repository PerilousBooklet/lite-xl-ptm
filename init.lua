-- mod-version:3
local core = require "core"
local command = require "core.command"
local config = require "core.config"
local keymap = require "core.keymap"
local DocView = require "core.docview"
local CommandView = require "core.commandview"

-- Configuration parameters
-- TODO: implement way to add template files from the user's init.lua
config.plugins.ptm = {}

-- TODO: formal docs
-- Template generation
local function template_generation(title)
	local dir = title
	local wd = os.execute("pwd")
	-- TODO: Windows/Mac/Linux support (check which operating system is running)
	-- TODO: check if there is a directory with the same name as the one from user input; if there is, refuse further instructions
	
	-- Create project directory
	system.mkdir(wd .. dir)
  
	-- Create files
  -- TODO: get files list (each file is assigned a string of text to contain)
  -- TODO: write iterator to create and fill files
  local filename
  -- TODO: get and assign filename from template file
	-- TODO: get and assign multi-line strings from template file
	-- TODO: write to the files the contents of the multi-line string tables
  os.execute("touch " .. wd .. "/" .. dir .. "/" .. filename)
	local file = io.open(wd .. "/" .. dir .. "/" .. filename, "w")
  
  local string = ""
  file:write(string)
  
  file:close()
end

-- TODO: formal docs
-- Template selection
local template_selection = function(t, title)
	-- Switch-case function implementation
    local switch = function(t)
        local case = {
        -- C++ simple
        ["cpp-simple"] = function()
          -- Create template from template description file located in ./templates
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
          -- TODO: spawn warning in status bar
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
  -- Get the input text for the template name
  core.command_view:enter("Choose template", {
    submit = function(text)
      -- Get the input text for the project title
      core.command_view:enter("Choose project title", {
        submit = function(title)
          -- Submit chosen template for selection
          template_selection(text, title)
        end
      })
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
--keymap.add { ["ctrl+shift+alt+p"] = "ptm:choose-template" }
