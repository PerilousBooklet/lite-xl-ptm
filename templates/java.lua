-- mod-version:3
local ptm = require 'plugins.ptm'

local lite_project = [[
local core = require "core"
local config = require "core.config"

table.insert(config.ignore_files, "^%.jtls$")
table.insert(config.ignore_files, "./*/.jdtls/")
table.insert(config.ignore_files, "src/target/")
]]


-- ?
