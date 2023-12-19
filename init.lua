-- mod-version:3
local core = require "core"
local command = require "core.command"
local config = require "core.config"
local keymap = require "core.keymap"
local DocView = require "core.docview"
local CommandView = require "core.commandview"

-- Configuration parameters
config.plugins.ptm = {}

-- WIP: formal docs
local function template_generation()
	-- foreach loop, loops for all multiline strings inside ? table located ?
	-- create variables
	local wd = os.execute("pwd")
	local dirname = "ex0"  -- TODO: get and assign dirname from input box
	local filename = "ex0.sh"
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

-- WIP: formal docs
local template_selection = function()
	-- Switch-case function implementation
    local switch = function(t)
        local case = {
        -- C++ simple
        ["cpp-simple"] = function()
          print("...")
          --template_generation()
        end,
        -- Java simple
        ["java-simple"] = function()
          print("...")
        end,
        -- Arch Linux's PKGBUILD
        ["pkbuild"] = function()
          print("...")
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

-- Commands
command.add(nil, {
  ["ptm:choose-template"] = function ()
    -- Get the input text
    core.command_view:enter("Choose template", {
      submit = function(text)
        print(text)
        template_selection(text)
      end
    })
  end
})

-- Key bindings
keymap.add { ["shift+alt+p"] = "ptm:choose-template" }
