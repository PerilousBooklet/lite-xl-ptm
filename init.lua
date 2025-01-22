-- mod-version:3 

local core = require "core"
local command = require "core.command"
local common = require "core.common"
local config = require "core.config"
local keymap = require "core.keymap"
-- local www = require "libraries.www"
local terminal = require "plugins.terminal"

local ptm = {}

-- Configuration Options
config.plugins.ptm = common.merge({
  -- ?
}, config.plugins.ptm)

-- Functions
local templates = {}
-- FUTURE_TODO: after PROJECT REWORK is complete, use core.root_project().path instead of core.project_dir

-- NOTE: this function will return the first template that matches
local function get_template(template_name)
	local template = nil
	for _, v in pairs(templates) do
		if template_name == v.name then
			template = v
		end
	end
	return template
end

-- Creates and fills a file
local function create_and_fill_file(project_title, dir, file_name, file_content)
	system.mkdir(core.project_dir .. "/" .. project_title .. "/" .. dir)
	local f = io.open(core.project_dir .. "/" .. project_title .. "/" .. dir .. "/" .. file_name, "w")
  f:write(file_content)
  f:close()
end

-- Download a file with lite-xl-www
-- FIX: cannot set undefined var connection ...
-- local agent = www.new()
-- local function download_file(file, filename)
--   local f = io.open(filename, "wb")
--   agent:get(file, {
--     response = function(response, chunk)
--       f:write(chunk)
--     end
--   })
-- end

-- Template generation
local function generate_template(template_name, project_title, template_content)
	-- Create and fill files
	for k, file in pairs(template_content.files) do
  	create_and_fill_file(project_title, file.path, k, file.content)
  end
  -- Create directories
  for k, dir in pairs(template_content.dirs) do
  	system.mkdir(core.project_dir .. "/" .. project_title .. "/" .. dir .. "/")
  end
  -- Download external libraries
  for k, lib in pairs(template_content.ext_libs) do
    system.chdir(core.project_dir .. "/" .. project_title .. "/" .. lib.path)
    --download_file(lib.url, lib.filename)
    -- TODO: Add timely queue for executing generation functions (es. no more sleep 3)
    -- TODO: Add download status in StatusView
    process.start({ "wget", lib.url })
  end
  -- Create and fill config files for the LSP server
  for k, file in pairs(template_content.lsp_config_files) do
  	create_and_fill_file(project_title, file.path, k, file.content)
  end
  -- Run commands
  for k, cmd in pairs(template_content.commands) do
  	system.chdir(core.project_dir .. "/" .. project_title)
  	-- FIX: fix commands list print inside terminal
  	command.perform("terminal:execute", table.concat(cmd, " "))
  end
end

-- Template selection
local function select_template(template_name, project_title)
  system.mkdir(core.project_dir .. "/" .. project_title)
  local template_content = get_template(template_name)
  generate_template(template_name, project_title, template_content)
end

-- Main
function ptm.add_template()
	return function (t)
    table.insert(templates, t)
  end
end

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

function ptm.load()
  -- Get template filenames
  local templates_list = parse_list()
  -- Load template files
  for _, v in ipairs(templates_list) do
    require("plugins.ptm.templates." .. v)
  end
end

local function project_template_manager()
  -- Get input for template name
  core.command_view:enter("Choose template", {
    -- Submit the desired template name
    submit = function(template_name)
      -- Get input for project folder title
      core.command_view:enter("Choose project title", {
        submit = function(project_title)
          -- Check if folder already exists
          if system.get_file_info(core.project_dir .. project_title) == nil then
            -- Submit chosen template for selection
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
      -- Get list of template names
      for k, v in pairs(templates) do
        table.insert(template_list, v["name"])
      end
      -- Match current input with templates names
      return common.fuzzy_match(template_list, template_name)
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
