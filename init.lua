-- mod-version:3 

local core = require "core"
local command = require "core.command"
local common = require "core.common"
local config = require "core.config"
local keymap = require "core.keymap"
local www = require "libraries.www"

local ptm = {}

-- FUTURE_TODO: after PROJECT REWORK is complete, use core.root_project().path instead of core.project_dir
-- FIX: after creating a new project, you can't save currently opened files from current working dir

-- Configuration Options
config.plugins.ptm = common.merge({
  -- ?
}, config.plugins.ptm)

local templates = {}

-- Return the first matching template
local function get_template(template_name)
	local template = nil
	for _, v in pairs(templates) do
		if template_name == v.name then
			core.log("Template found: " .. template_name)
			return v
		end
	end
	core.log("Template not found: " .. template_name)
	return nil
end

-- Create and fill file
local function create_and_fill_file(project_title, dir, file_name, file_content)
	core.log("Create folder: " .. core.project_dir .. "/" .. project_title .. "/" .. dir)
	local f = io.open(core.project_dir .. "/" .. project_title .. "/" .. dir .. "/" .. file_name, "w")
  if f then
    f:write(file_content)
    f:close()
    core.log("Created file: " .. core.project_dir .. "/" .. project_title .. "/" .. dir .. "/" .. file_name)
  else
    core.log("Error: could not open file: " .. file_name)
  end
end

-- Download remote file
-- WIP: fix, cannot set undefined var connection ...
local agent = www.new()
local function download_file(file, filename)
  local f = io.open(filename, "wb")
  core.add_thread(function()
    agent:get(file, {
      response = function(response, chunk)
        f:write(chunk)
      end
    })
  end)
end

-- Template generation
local function generate_template(template_name, project_title, template_content)
  -- Create directories
  for k, dir in pairs(template_content.dirs) do
  	system.mkdir(core.project_dir .. "/" .. project_title .. "/" .. dir .. "/")
  end
	-- Create and fill files
	for k, file in pairs(template_content.files) do
  	create_and_fill_file(project_title, file.path, k, file.content)
  end
  -- Download external libraries
  for k, lib in pairs(template_content.ext_libs) do
    system.chdir(core.project_dir .. "/" .. project_title .. "/" .. lib.path)
    -- FUTURE_TODO: Add download status in StatusView (use log messages)
    -- WIP: commands should run only when the deps are finished downloading
    -- EXAMPLE FROM ADAM:
    -- core.add_thread(function()
    --   local result1 = process.start({ "process1" }).stdout:read("*all")
    --   local result2 = process.start({ "process2" }).stdout:read("*all")   
    -- end)
    core.add_thread(function ()
    	process.start({ "wget", lib.url })
    	-- download_file(lib.url, lib.filename)
    end)
  end
  -- Create and fill config files for LSP servers
  for k, file in pairs(template_content.lsp_config_files) do
  	create_and_fill_file(project_title, file.path, k, file.content)
  end
  -- Run commands
  for k, cmd in pairs(template_content.commands) do
  	system.chdir(core.project_dir .. "/" .. project_title)
  	command.perform("terminal:execute", table.concat(cmd, " "))
  end
  -- TODO: add Lite XL project file (es. for integration with build/debugger plugins)
end

-- Template selection
local function select_template(template_name, project_title)
  system.mkdir(core.project_dir .. "/" .. project_title)
  local template_content = get_template(template_name)
  if template_content then
    core.log("Template found: " .. template_name)
    generate_template(template_name, project_title, template_content)
  else
    core.log("Error: template not found!")
  end
end

-- Add a template table to the templates table
function ptm.add_template()
	return function (t)
    table.insert(templates, t)
  end
end

-- Get list of template files
local function parse_list()
	local list = system.list_dir(USERDIR .. "/plugins/ptm/templates")
  local list_matched = {}
  local temp_string = ""
  for k, v in pairs(list) do
    temp_string = string.gsub(list[k], ".lua", "")
    table.insert(list_matched, temp_string)
  end
  return list_matched
end

-- Load templates
function ptm.load()
  -- Get template filenames
  local templates_list = parse_list()
  -- Load template files
  for _, v in ipairs(templates_list) do
    require("plugins.ptm.templates." .. v)
  end
end

-- Main
local function project_template_manager()
  -- Get input for template name
  core.command_view:enter("Choose template", {
    -- Submit the desired template name
    submit = function(template_name)
      -- Get input for project title
      core.command_view:enter("Choose project title", {
        submit = function(project_title)
          -- TODO: prompt for more data, es. author name (es. for Maven)
          -- Check if folder already exists
          if system.get_file_info(core.project_dir .. "/" .. project_title) == nil then
            select_template(template_name, project_title)
          else
            core.log("WARNING: a folder with this title exists already!")
          end
        end
      })
    end,
    -- Suggest template names
    suggest = function(template_name)
      local template_list = {}
      for k, v in pairs(templates) do
        table.insert(template_list, v["name"])
      end
      return common.fuzzy_match(template_list, template_name)
    end
  })
end

-- Command
command.add(nil, {
  ["ptm:choose-template"] = function ()
    project_template_manager()
  end
})

-- Key binding
keymap.add {
  ["alt+p"] = "ptm:choose-template"
}

return ptm
