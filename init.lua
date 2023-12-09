-- mod-version:3
local core = require "core"
local command = require "core.command"
local keymap = require "core.keymap"
local DocView = require "core.docview"
local CommandView = require "core.commandview"

-- ?
local last_view, last_fn, last_text, last_sel

-- ?
local function doc()
  local is_DocView = core.active_view:is(DocView) and not core.active_view:is(CommandView)
  return is_DocView and core.active_view.doc or (last_view and last_view.doc)
end

-- Create input view ?
core.command_view:enter("Choose template " .. kind, {
  text = default,
  select_text = true,
  show_suggestions = false,
  submit = function(old)
    insert_unique(core.previous_find, old)
    local s = string.format("Replace %s %q With", kind, old)
      core.command_view:enter(s, {
        text = old,
        select_text = true,
        show_suggestions = true,
        submit = function(new)
          core.status_view:remove_tooltip()
          insert_unique(core.previous_replace, new)
          local results = doc():replace(function(text)
            return fn(text, old, new)
          end)
          local n = 0
          for _,v in pairs(results) do
            n = n + v
          end
          core.log("Replaced %d instance(s) of %s %q with %q", n, kind, old, new)
        end,
        suggest = function() return core.previous_replace end,
        cancel = function()
          core.status_view:remove_tooltip()
        end
      })
    end,
    suggest = function() return core.previous_find end,
    cancel = function()
      core.status_view:remove_tooltip()
    end
})

-- ?

-- Generate selected template
local function template_generation()
	-- assign current working directory to a variable
	-- get project directory name from command.view input
	-- check if there is a directory with the same name as the one from user input; if there is, refuse further instructions
	-- create directory
	-- create the specified files
	-- write to the files the contents of the multi-line string tables
end

-- Assign template from user input
local template_selected = function()
	-- Switch-case function implementation
    local switch = function(t)
        local case = {
        -- C++ cmake
        ["cpp-cmake"] = function()
            print("Your choice is cpp-cmake")
        end,
        -- C++ meson
        ["cpp-meson"] = function()
            print("Your choice is cpp-meson")
        end,
        -- C++ simple
        ["cpp-simple"] = function()
            print("Your choice is cpp-simple")
        end,
        default = function()
            print("Your input didn't match any of the predefined templates.")
        end,
        }
        if case[t] then
            case[t]()
        else
            case["default"]()
        end
    end
    switch(t)
end

-- Commands
command.add("core.docview!", {
  ["ptm:choose-template"] = function ()
    -- Create a command view to input the template name
    core.command_view:enter("Choose template:", {
      -- Get the input text
      -- ?
      -- Call the template assignment
      local template = template_selected(input_text)
      -- Call the template generation
      template_generation(template)
    })
  end
})

-- Key bindings
keymap.add { ["shift+alt+p"] = "ptm:choose-template" }
