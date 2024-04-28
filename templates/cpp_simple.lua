-- mod-version:3 lite-xl 2.1
local ptm = require 'plugins.ptm'

ptm.add_template {
    name = "cpp_simple",
    files    = { "main.cpp", "run.sh" },
    desc     = 'Very simple, single-file C++ project',
    template1 = [[
]],
    template2 = [[

]],
    commands = { "", "" }
}
