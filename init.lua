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

local ptm = {}
local wd = system.absolute_path(".")
local templates = {
  ["prova"] = {
    files = {
      ["file1.txt"] = {
        path = "/" .. "dir1" .. "/" .. "dir1_1",
        content = [[
[intro]
text = \"This is the file's content, a multi-line string.\"
]]
      }
    },
    dirs = {
      "/" .. "dir2",
      "/" .. "dir3"
    },
    commands = {
      "echo Hello there!"
    }
  },
}

-- TODO: write function to merge template tables
local function add(template)
  -- ...
end

-- file creation function
local function create_and_fill_file(dir, file, content)
	-- Create directory where file resides
	system.mkdir(wd .. "/" .. dir)
	-- Create file
	local f = io.open(wd .. "/" .. dir .. "/" .. file, "w")
  f:write(content)
  f:close()
end

-- Template generation
local function template_generation(template)
	-- Create and fill files
	for key, file in pairs(template.files) do
  	create_and_fill_file(file.path, file.name, file.content)
  end
  create_file(dir, file, content)
  -- Create directories
  for key, dirname in ipairs(template.dirs) do
  	system.mkdir(wd .. dir)
  end
  -- Run commands
  for key, command in ipairs(template.commands) do
  	process.start(command)
  end
end

-- Template selection
local function template_selection(t, title)
  for key, value in pairs(templates) do
    if key == title then
    	template_generation(key)
    end
  end
end

-- Main function
local function project_template_manager()
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
    	-- TODO: return suggestions as names of files
      -- TODO: filter suggestions matching already entered characters (es. common.fuzzy_match)
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

return ptm
