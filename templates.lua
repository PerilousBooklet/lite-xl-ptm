local ptm = require 'plugins.ptm'

-- C++ - Simple
ptm.add {
    name = "cpp_simple",
    files    = { "main.cpp", "run.sh" },
    desc     = 'Very simple, single-file C++ project',
    template1 = [[
]],
    template2 = [[

]],
    commands = { "", "" }
}

