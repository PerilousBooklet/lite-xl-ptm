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
local function template_generation(text, title)
	-- for-each loop, loops for all multiline strings inside template table
	local wd = os.execute("pwd")
	local dirname = t
	local filename = t .. ".sh"
	-- get project directory name from command.view input
	-- check if there is a directory with the same name as the one from user input; if there is, refuse further instructions
	-- create directory
  os.execute("mkdir " .. wd .. dirname)
	-- create the specified files
  os.execute("touch " .. wd .. "/" .. dirname .. "/" .. filename) -- TODO: get and assign filename from template .lua file
	-- write to the files the contents of the multi-line string tables
	local file = io.open(wd .. "/" .. dirname .. "/" .. filename, "w")
  local mls = "#!/bin/bash"  -- example
  file:write(mls) -- TODO: get and assign multi-line strings from template .lua file
  file:close()
end

-- TODO: formal docs
-- Template selection
local template_selection = function(t)
	-- Switch-case function implementation
    local switch = function(t)
        local case = {
        -- C++ simple
        ["cpp-simple"] = function()
          print("cpp")
          -- Create template from template description file located in ./templates
          --template_generation()
        end,
        -- Java simple
        ["java-simple"] = function()
          print("java")
        end,
        -- Arch Linux's PKGBUILD
        ["pkgbuild-simple"] = function()
          print(t)
        end,
        -- ?
        default = function()
          print("Your input didn't match any of the predefined templates.")
        end,
        }
        -- ?
        if case[t] then
          case[t]()
        else
          case["default"]()
        end
    end
    switch(t)
end

local project_template_manager = function()
  -- TODO: Implement template name suggestions list above command view
  -- Get the input text for the template name
  core.command_view:enter("Choose template", {
    submit = function(text)
      -- Get the input text for the project title
      core.command_view:enter("Choose project title", {
        submit = function(title)
          print(title)
        end
      })
      -- Submit chosen template for selection
      template_selection(text)
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
keymap.add { ["shift+alt+p"] = "ptm:choose-template" }
