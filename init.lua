-- mod-version:3 

local core = require "core"
local command = require "core.command"
local common = require "core.common"
local config = require "core.config"
local keymap = require "core.keymap"
local style = require "core.style"

local www = require "libraries.www"

-------
-- ? --
-------

local ptm = {}

---------------------------
-- Configuration Options --
---------------------------

config.plugins.ptm = common.merge({
  -- ?
}, config.plugins.ptm)

----------
-- Core --
----------

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

-- ROUND 2 PATCH (project title sanitization): project_title was
-- previously concatenated straight into filesystem paths with no
-- validation, so a crafted title like "../../etc" (or an empty
-- string) could make the plugin create/write files outside
-- core.project_dir entirely. This rejects empty titles and anything
-- containing a path separator or a ".." component before it's ever
-- used to build a path.
local function sanitize_project_title(title)
  if not title or title:match("^%s*$") then
    return nil, "project title cannot be empty"
  end
  if title:find("[/\\]") then
    return nil, "project title cannot contain a path separator"
  end
  if title:find("%.%.") then
    return nil, 'project title cannot contain ".."'
  end
  return title
end

-- Create and fill file
-- PATCH 1 (directory auto-creation): now takes the *absolute* project
-- path rather than re-deriving it from project_title, and creates the
-- file's parent directory with common.mkdirp before writing. This is
-- what was actually missing before -- template.dirs and the paths
-- used by files/lsp_config_files/ext_libs were two independently
-- hand-maintained lists that had to agree by convention; now a file's
-- own `path` is authoritative and self-sufficient.
-- PATCH 6 (portability): uses PATHSEP instead of a hardcoded "/".
local function create_and_fill_file(project_path, dir, file_name, file_content)
  local target_dir = project_path .. PATHSEP .. dir
  common.mkdirp(target_dir)
  local full_path = target_dir .. PATHSEP .. file_name
  core.log("Create folder: " .. target_dir)
	local f = io.open(full_path, "w")
  if f then
    f:write(file_content)
    f:close()
    core.log("Created file: " .. full_path)
  else
    core.log("Error: could not open file: " .. full_path)
  end
end

-- Create and fill single file (for single-file templates)
-- PATCH 6 (portability): uses PATHSEP instead of a hardcoded "/".
local function create_and_fill_single_file(file_name, file_content)
	local f = io.open(core.project_dir .. PATHSEP .. file_name, "w")
  if f then
    f:write(file_content)
    f:close()
    core.log("Created file: " .. core.project_dir .. PATHSEP .. file_name)
  else
    core.log("Error: could not open file: " .. file_name)
  end
end

-- Download remote file
-- PATCH 2 (ordering) support: now accepts an `on_done` callback, called
-- exactly once whether the download succeeds or fails, so callers
-- (generate_template below) can tell when it's actually safe to move on
-- to commands that might depend on this file. Previously nothing
-- signalled completion back to the caller at all.
-- Also guards against `f` being nil (e.g. if the destination directory
-- doesn't exist), which previously would throw inside the response
-- callback instead of failing gracefully.
local function download_file(url, filename, on_done)
  local f = io.open(filename, "wb")
  if not f then
    core.error("Download failed: could not open destination file: " .. filename)
    if on_done then on_done("could not open destination file: " .. filename) end
    return
  end
  local agent = www.new()
  core.add_thread(function()
    agent:get(url, {
      response = function(response, chunk)
        f:write(chunk)
      end,
      -- PATCH (related fix): core.log messages from background threads
      -- can get silently overwritten before they're seen. Use the same
      -- status_view mechanism as the "Downloading..." message below so
      -- completion is actually visible.
      done = function()
        f:close()
        core.status_view:show_message("i", style.text, "Downloaded: " .. filename)
        if on_done then on_done(nil) end
      end,
      error = function(err)
        f:close()
        core.error("Download failed: " .. tostring(err))
        if on_done then on_done(err) end
      end
    })
  end)
end

-- Template generation
-- PATCH 1 (directory auto-creation) + PATCH 6 (portability): all path
-- joining now goes through an absolute `project_path` computed once,
-- with PATHSEP throughout; create_and_fill_file creates its own parent
-- directory, so template.dirs is only needed for directories that
-- don't already get created as a side effect of a file being written
-- into them (e.g. empty directories, or ext_libs destinations).
--
-- PATCH 2 (ordering): commands no longer run immediately after kicking
-- off ext_libs downloads. Downloads are asynchronous (see
-- download_file/core.add_thread above), so previously `commands` could
-- -- and typically would -- run before any downloaded dependency
-- actually existed on disk. Now a pending-download counter defers
-- `commands` until every ext_lib's on_done callback has fired
-- (success or failure).
--
-- PATCH 3 (command quoting): each argument in a command table is now
-- shell-quoted individually before being joined, so arguments
-- containing spaces (or other shell-significant characters) are no
-- longer word-split by the shell.
--
-- ROUND 2 PATCH (chdir): download_file already receives an absolute
-- destination path, so the system.chdir(lib_dir) call that used to
-- precede each download was redundant -- it mutated global process
-- state for no reason, since nothing about the download actually
-- depended on cwd. It's removed here. The chdir before `commands`
-- is kept, since command.perform("terminal:execute", ...) is a plain
-- shell string with no separate "working directory" argument exposed
-- to this plugin, so cwd is genuinely the only lever available for
-- that one. This remaining chdir is still a piece of global mutable
-- state shared with everything else running in the editor process --
-- worth revisiting if/when terminal:execute grows a cwd parameter.
local function generate_template(project_path, template_content)
  -- Create directories
  for _, dir in ipairs(template_content.dirs) do
    common.mkdirp(project_path .. PATHSEP .. dir)
  end
	-- Create and fill files
	for k, file in pairs(template_content.files) do
  	create_and_fill_file(project_path, file.path, k, file.content)
  end
  -- Create and fill config files for LSP servers
  for k, file in pairs(template_content.lsp_config_files) do
  	create_and_fill_file(project_path, file.path, k, file.content)
  end

  -- Run commands. Extracted into its own function so it can be called
  -- either immediately (no ext_libs to wait for) or once every
  -- download has finished (see the pending-counter below).
  local function run_commands()
    for _, cmd in ipairs(template_content.commands) do
      system.chdir(project_path)
      local quoted_args = {}
      for i, arg in ipairs(cmd) do
        quoted_args[i] = string.format("%q", arg)
      end
      command.perform("terminal:execute", table.concat(quoted_args, " "))
    end
  end

  local pending = #template_content.ext_libs
  if pending == 0 then
    run_commands()
    return
  end

  for _, lib in ipairs(template_content.ext_libs) do
    local lib_dir = project_path .. PATHSEP .. lib.path
    common.mkdirp(lib_dir)
    core.status_view:show_message("i", style.text, "Downloading dependencies...")
    download_file(lib.url, lib_dir .. PATHSEP .. lib.filename, function(err)
      if err then
        core.error("Dependency download failed, commands were not run: " .. tostring(err))
        return
      end
      pending = pending - 1
      if pending == 0 then
        run_commands()
      end
    end)
  end
  -- TODO: add Lite XL project file (es. for integration with build/debugger plugins)
end

-- Template selection
-- PATCH 4 (validate before creating anything): callers are now
-- expected to have already resolved `template_content` via
-- get_template (see project_template_manager below) before this runs
-- at all, so by the time we get here the template is known-valid and
-- system.mkdir only ever creates a folder for a template that will
-- actually be generated.
-- ROUND 2 PATCH: takes the already-fetched template table directly
-- instead of a template_name it would have to re-look-up, removing a
-- redundant get_template call and any chance of it disagreeing with
-- the caller's own lookup.
local function select_template(template_content, project_title)
  local project_path = core.project_dir .. PATHSEP .. project_title
  system.mkdir(project_path)
  generate_template(project_path, template_content)
end

-- Select single-file template
-- ROUND 2 PATCH: takes the already-fetched template table directly,
-- same reasoning as select_template above.
local function select_single_file_template(template_content)
  core.log("Generating single-file template: " .. template_content.name)
  for k, file in pairs(template_content.files) do
    create_and_fill_single_file(k, file.content)
  end
end

------------------
-- Data Storage --
------------------

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
  for _, name in pairs(list) do
    -- PATCH (related fix): `string.gsub(name, ".lua", "")` used a Lua
    -- *pattern* where "." matches any character, not a literal dot --
    -- it could strip an extra character and/or misfire on names that
    -- contain "lua" elsewhere, and didn't filter out non-.lua entries
    -- at all (those would then be require()'d as-is and error). This
    -- anchors to a literal, escaped ".lua" suffix and skips anything
    -- that doesn't match it.
    local template_name = name:match("^(.+)%.lua$")
    if template_name then
      table.insert(list_matched, template_name)
    end
  end
  return list_matched
end

-- Load templates
function ptm.load()
  -- Get template filenames
  local templates_list = parse_list()
  -- Load template files
  for _, v in ipairs(templates_list) do
    -- PATCH (related fix): a broken template file previously threw and
    -- aborted the whole loop, silently skipping every template loaded
    -- after it. core.try isolates each template's require so one bad
    -- file doesn't take the rest down with it.
    core.try(function()
      require("plugins.ptm.templates." .. v)
      core.log("Loaded ptm module: " .. v)
    end)
  end
end

----------
-- Main --
----------

-- ROUND 2 PATCH (single-file template mechanism): previously a
-- template was treated as "single-file" purely by the *display name*
-- containing the literal substring "(single)" -- e.g.
-- string.find(template_name, "(single)") -- which was never actually
-- documented or demonstrated by any template, matched as a substring
-- rather than an exact convention (so a template legitimately named
-- e.g. "single-page-app" would misfire), and offered no way to tell
-- templates apart other than eyeballing their name.
--
-- This replaces it with an explicit `single = true` field on the
-- template table itself (alongside `name`/`desc`/`files`/etc.),
-- checked directly on the already-fetched template object. Template
-- authors marking a template as single-file should now set
-- `single = true` in their plugins.ptm.add_template() call instead of
-- relying on a naming convention.
--
-- This also fixes the earlier "folder created before template
-- validity is checked" issue one step further upstream: template
-- existence is now checked immediately after the template name is
-- submitted, *before* the project-title prompt is even shown, instead
-- of only being checked once select_template() got around to it.
local function project_template_manager()
  -- Get input for template name
  core.command_view:enter("Choose template", {
    -- Submit the desired template name
    submit = function(template_name)
      local template_content = get_template(template_name)
      if not template_content then
        core.error("Error: template not found: " .. template_name)
        return
      end

      -- For single-file templates
      if template_content.single then
      	select_single_file_template(template_content)
      -- For complex project templates
      else
        core.command_view:enter("Choose project title", {
          submit = function(project_title)
            local sanitized, err = sanitize_project_title(project_title)
            if not sanitized then
              core.error("Invalid project title: " .. err)
              return
            end
            -- Check if folder already exists
            if system.get_file_info(core.project_dir .. PATHSEP .. sanitized) == nil then
              select_template(template_content, sanitized)
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

--------------
-- Commands --
--------------

command.add(nil, { ["ptm:choose-template"] = function () project_template_manager() end })

-----------------
-- Keybindings --
-----------------

keymap.add { ["alt+p"] = "ptm:choose-template" }

-------
-- ? --
-------

core.add_thread(function() ptm.load() end)

return ptm
