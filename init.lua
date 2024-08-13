-- mod-version:3 lite-xl 2.1
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

-- TODO: Add modular system to load external libraries
-- TODO: Optimize external libraries visibility to LSP for go-to-definition, with a readonly open_doc() function
-- TODO: Add auto-insert upon file-creation (es. Minecraft modding java files)
-- TODO: use Adam's lite-xl-www to download dependencies in the functions that setup the external libraries
-- TODO: add project-template-specific tab to explain manual steps / clarifications (based on WIP dashboard plugin)

local function add_template(template)
  common.merge(template, config.plugins.ptm)
end

-- Creates and fills a file
local function create_and_fill(title, dir, file, content)
	-- Create directory where file resides
	system.mkdir(wd .. "/" .. title .. "/" .. dir)
	-- Create file
	local f = io.open(wd .. "/" .. title .. "/" .. dir .. "/" .. file, "w")
  f:write(content)
  f:close()
end

-- Template generation
local function template_generation(template, title)
	-- Create and fill files
	for key, file in pairs(template.files) do
  	create_and_fill(title, file.path, file.name, file.content)
  end
  -- Create directories
  for key, dir in ipairs(template.dirs) do
  	system.mkdir(wd .. "/" .. title .. "/" .. dir .. "/")
  end
  -- Download dependencies
  for key, dep in ipairs(template.dependencies) do
  	system.chdir(wd .. "/" .. title) -- Chanfe dir into project dir
  	-- ...
  end
  -- Run commands
  for key, command in ipairs(template.commands) do
  	system.chdir(wd .. "/" .. title) -- Chanfe dir into project dir
  	process.start(command)
  end
end

-- Template selection
local function template_selection(template, title)
  for key, value in pairs(config.plugins.ptm) do
    if key == template then
    	system.mkdir(wd .. title) -- Create project folder
    	template_generation(title, template)
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
