-- mod-version:3 

local core = require "core"
local command = require "core.command"
local common = require "core.common"
local config = require "core.config"
local keymap = require "core.keymap"
local www = require "libraries.www.www" -- the path www.www will be fixed

local ptm = {}

config.plugins.ptm = common.merge({
  -- ?
}, config.plugins.ptm)

-- MessageView


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

-- TODO: Add project-template-specific tab to explain manual steps / clarifications (use an EmptyView)
-- ex. a gradle project requires interaction with the user

-- Creates and fills a file
local function create_and_fill(project_title, dir, file_name, file_content)
	system.mkdir(wd .. "/" .. project_title .. "/" .. dir)
	local f = io.open(wd .. "/" .. project_title .. "/" .. dir .. "/" .. file_name, "w")
  f:write(file_content)
  f:close()
end

-- Download a file with lite-xl-www
-- WIP: Download function
local function download_file(file, filename)
  core.add_thread(function()
    local f = io.open(filename, "wb")
    www.request({
      url = file,
      response = function(response, chunk)
        print(response.status)
        f:write(chunk)
      end
    })
  end)
end

-- Template generation
local function template_generation(template_name, project_title, template_content)
	-- Create and fill files
	for k, file in pairs(template_content.files) do
  	create_and_fill(project_title, file.path, k, file.content)
  end
  -- Create directories
  for k, dir in pairs(template_content.dirs) do
  	system.mkdir(wd .. "/" .. project_title .. "/" .. dir .. "/")
  end
  -- Download external libraries
  -- for k, lib in pairs(template_content.ext_libs) do
  -- 	system.chdir(wd .. "/" .. project_title .. "/" .. lib.dir)
  -- 	download_file(lib.file, k)
  -- end
  -- Create and fill config files for the LSP server
  for k, file in pairs(template_content.lsp_config_files) do
  	create_and_fill(project_title, file.path, k, file.content)
  end
  -- Run commands
  for k, command in pairs(template_content.commands) do
  	system.chdir(wd .. "/" .. project_title)
  	-- TODO: use coroutines to manage command runs
  	-- TODO: open the terminal plugin and run the command
  	process.start(command)
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
  -- Get input for template name
  core.command_view:enter("Choose template", {
    -- Submit the desired template name
    submit = function(template_name)
      -- Get input for project folder title
      core.command_view:enter("Choose project title", {
        submit = function(project_title)
          -- Check if folder already exists
          if system.get_file_info(wd .. project_title) == nil then
            -- Submit chosen template for selection
            template_selection(template_name, project_title)
          else
            core.log("WARNING: a folder with this title exists already!")
          end
        end
      })
    end,
    -- Suggest template names
    suggest = function(template_name)
      local template_list = {}
      -- Get list of template names
      for k, v in pairs(templates) do
        table.insert(template_list, v["name"])
      end
      -- Match current input with templates names
      return common.fuzzy_match(template_list, template_name)
    end
  })
end

-- Init
-- not required (Lite XL automatically runs the ptm_*.lua files)

-- Commands
command.add(nil, {
  ["ptm:choose-template"] = function ()
    project_template_manager()
    -- TODO: Spawn MessageView
  end
})

-- Key bindings
keymap.add {
  ["alt+p"] = "ptm:choose-template"
}

-- TODO: Rework current table filling logic with the one from the snippets/lsp plugin
-- Filling the templates table (copied from the formatter plugin)
return {
	add_template = function(template)
	  table.insert(templates, template)
	end
}
