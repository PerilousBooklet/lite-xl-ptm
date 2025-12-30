-- mod-version:3 

local core = require "core"
local command = require "core.command"
local common = require "core.common"
local config = require "core.config"
local keymap = require "core.keymap"
local style = require "core.style"

local www = require "libraries.www"


local ptm = {}

-- Configuration Options
config.plugins.ptm = common.merge({
  -- ?
}, config.plugins.ptm)

-- FUTURE_TODO: after PROJECT REWORK is complete, use core.root_project().path instead of core.project_dir

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

-- Create and fill single file (for single-file templates)
local function create_and_fill_single_file(file_name, file_content)
	local f = io.open(core.project_dir .. "/" .. file_name, "w")
  if f then
    f:write(file_content)
    f:close()
    core.log("Created file: " .. core.project_dir .. "/" .. file_name)
  else
    core.log("Error: could not open file: " .. file_name)
  end
end

-- TODO: write task queue system to make sure commands run only after deps have finished downloading

-- Download remote file
local function download_file(url, filename)
  local f = io.open(filename, "wb")
  local agent = www.new()
  core.add_thread(function()
    agent:get(url, {
      response = function(response, chunk)
        f:write(chunk)
      end,
      -- FIX: message not shown
      done = function()
        f:close()
        core.log("Downloaded: " .. filename)
      end,
      error = function(err)
        f:close()
        core.error("Download failed: " .. tostring(err))
      end
    })
  end)
end

-- Template generation
-- FIX: after creating a new project, you can't save currently opened files from current working dir
--      (the plugin changes the current project dir ?, you see it in the difference between 
--       the terminal path and treeview top-level directory)
local function generate_template(template_name, project_title, template_content)
  -- Create directories
  for _, dir in ipairs(template_content.dirs) do
  	system.mkdir(core.project_dir .. "/" .. project_title .. "/" .. dir .. "/")
  end
	-- Create and fill files
	for k, file in pairs(template_content.files) do
  	create_and_fill_file(project_title, file.path, k, file.content)
  end
  -- Download external libraries
  for _, lib in ipairs(template_content.ext_libs) do
    system.chdir(core.project_dir .. "/" .. project_title .. "/" .. lib.path)
    core.status_view:show_message("i", style.text, "Downloading dependencies...")
    download_file(lib.url, lib.filename)
  end
  -- Create and fill config files for LSP servers
  for k, file in pairs(template_content.lsp_config_files) do
  	create_and_fill_file(project_title, file.path, k, file.content)
  end
  -- Run commands
  for _, cmd in ipairs(template_content.commands) do
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

-- Select single-file template
local function select_single_file_template(template_name)
  local template_content = get_template(template_name)
  if template_content then
    core.log("Template found: " .. template_name)
    -- Create and fill single files
    for k, file in pairs(template_content.files) do
      create_and_fill_single_file(k, file.content)
    end
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
      -- For single-file templates
      if string.find(template_name, "(single)") then
      	select_single_file_template(template_name)
      -- For complex project templates
      else
        core.command_view:enter("Choose project title", {
          submit = function(project_title)
            -- TODO: prompt for more data (use one more commandview, use ; or | to separate arguments)
            -- 1. I need the template folder name and the organization path (es. com.mycompany.example_app) for the Maven quickstart archetype
            -- maybe a way to specify (in the template file) how many arguments to ask for ?
            -- Check if folder already exists
            if system.get_file_info(core.project_dir .. "/" .. project_title) == nil then
              select_template(template_name, project_title)
            else
              core.log("WARNING: a folder with this title exists already!")
            end
          end
        })
      end
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
command.add(nil, { ["ptm:choose-template"] = function () project_template_manager() end })

-- Keybind
keymap.add { ["alt+p"] = "ptm:choose-template" }

return ptm
