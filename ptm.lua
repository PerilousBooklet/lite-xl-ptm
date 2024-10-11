-- mod-version:3 

local core = require "core"
local command = require "core.command"
local common = require "core.common"
local config = require "core.config"
local keymap = require "core.keymap"

config.plugins.ptm = common.merge({
  -- ?
}, config.plugins.ptm)

local templates = {}
local wd = system.absolute_path(".")

-- this function will return the first template that matches
local function get_template(template_name)
	local template = nil
	for _, v in pairs(templates) do
		if template_name == v.name then
			template = v
		end
	end
	return template
end

-- TODO: add project-template-specific tab to explain manual steps / clarifications (use an EmptyView)
-- ex. a gradle project requires interaction with the user

-- Creates and fills a file
local function create_and_fill(project_title, dir, file_name, file_content)
	system.mkdir(wd .. "/" .. project_title .. "/" .. dir)
	local f = io.open(wd .. "/" .. project_title .. "/" .. dir .. "/" .. file_name, "w")
  f:write(file_content)
  f:close()
end

-- Template generation
local function template_generation(template_name, project_title, template_content)
	-- Create and fill files
	for key, file in pairs(template_content.files) do
  	create_and_fill(project_title, file.path, key, file.content)
  end
  -- Create directories
  for key, dir in pairs(template_content.dirs) do
  	system.mkdir(wd .. "/" .. project_title .. "/" .. dir .. "/")
  end
  -- Download external libraries
  for key, lib in pairs(template_content.ext_libs) do
  	--system.chdir(wd .. "/" .. project_title .. "/" .. lib.dir)
  	-- TODO: use Adam's lite-xl-www to download dependencies
  end
  -- Crete and fill config files for the LSP server
  for key, file in pairs(template_content.lsp_config_files) do
  	create_and_fill(project_title, file.path, key, file.content)
  end
  -- Run commands
  for key, command in pairs(template_content.commands) do
  	--system.chdir(wd .. "/" .. project_title)
  	--process.start(command)
  end
  -- Write template-specific message
  -- ?
end

-- Template selection
local function template_selection(template_name, project_title)
  system.mkdir(wd .. "/" .. project_title) -- Rn it stops here
  local template_content = get_template(template_name)
  template_generation(template_name, project_title, template_content)
end

-- Main function
local function project_template_manager()
  -- Get input text for template name
  core.command_view:enter("Choose template", {
    submit = function(template_name)
      -- Get input text for project folder title
      core.command_view:enter("Choose project title", {
        submit = function(project_title)
          -- Check if folder already exists
          if system.get_file_info(wd .. project_title) == nil then
            -- Submit chosen template for selection
            template_selection(template_name, project_title)
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

-- Init
-- not required (Lite XL automatically runs the ptm_*.lua files)

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

-- Filling the templates table (copied from the formatter plugin)
return {
	add_template = function(template)
	  table.insert(templates, template)
	end
}
