-- mod-version:3
local core = require "core"
local command = require "core.command"
local common = require "core.common"
local config = require "core.config"
local keymap = require "core.keymap"

-- Configuration parameters
config.plugins.ptm = common.merge({
  -- ?
}, config.plugins.ptm)

-- Constants
local wd = system.absolute_path(".")
local mlstring = [[
#!/bin/bash
echo "It works!"
]]

-- Template generation
local function template_generation(dir)	
	-- Create directory
	system.mkdir(wd .. "/" .. dir)
  
	-- Create file
  local file = "abcd.sh"
  local f = io.open(wd .. "/" .. dir .. "/" .. file, "w")
  f:write(mlstring)
  f:close()
end

-- Template selection
local template_selection = function(t, title)
  -- Switch-case selection implementation
  local switch = function(t)
    local case = {
      ["cpp-simple"] = function()
        template_generation(title)
      end,
      default = function()
        core.log_quiet({"WARNING: the input didn't match any of the predefined templates!"})
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
