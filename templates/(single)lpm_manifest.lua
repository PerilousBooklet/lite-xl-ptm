-- mod-version:3
local ptm = require 'plugins.ptm'

-- Reference Docs
-- https://github.com/lite-xl/lite-xl-plugin-manager/blob/master/SPEC.md#example-file

local content = [[
{
  "addons": [ # The addons array contains a list of all addons registered on this repository.
    {
      "id": "plugin_manager", # Unique name, used to reference the plugin.
      "version": "0.1", # Semantic version.
      "description": "A GUI interface to the Adam's lite plugin manager.", # English description of the plugin.
      "path": "plugins/plugin_manager", # The path to the plugin in this repository.
      "mod_version": "3", # The mod_version this plugin corresponds to.
      "provides": [ # A list of small strings that represent functionalities this plugin provides.
        "plugin-manager"
      ],
      "files": [ # A list of files (usually binaries) this plugin requires to function.
        {
          "url": "https://github.com/adamharrison/lite-xl-plugin-manager/releases/download/v0.1/lpm.x86_64-linux", # A publically accessible URL to download from.
          "arch": "x86_64-linux", # The lite-xl/clang target tuple that represents the architecture this file is for.
          "checksum": "d27f03c850bacdf808436722cd16e2d7649683e017fe6267934eeeedbcd21096" # the sha256hex checksum that corresponds to this file.
        },
        {
          "url": "https://github.com/adamharrison/lite-xl-plugin-manager/releases/download/v0.1/lpm.x86_64-windows.exe",
          "arch": "x86_64-windows",
          "checksum": "2ed993ed4376e1840b0824d7619f2d3447891d3aa234459378fcf9387c4e4680"
        }
      ],
      "dependencies": {
        "json": {} # Depeneds on `json`, can be a plugin's name or one of its `provides`.
      }
    },
    {
      "id": "RobotoMono",
      "version": "0.1",
      "type": "font",
      "description": "Roboto Mono font.",
      "files": [ # Downloads all files listed here to USERDIR/fonts.

        {
          "url": "https://github.com/googlefonts/RobotoMono/raw/26adf5193624f05ba1743797d00bcf0e6bfe624f/fonts/ttf/RobotoMono-Regular.ttf",
          "checksum": "7432e74ff02682c6e207be405f00381569ec96aa247d232762fe721ae41b39e2"
        }
      ]
    },
    {
      "id": "json",
      "version": "1.0",
      "description": "JSON support plugin, provides encoding/decoding.",
      "type": "library",
      "path": "plugins/json.lua",
      "provides": [
        "json"
      ]
    },
    {
      "tags": ["language"],
      "description": "Syntax for .gitignore, .dockerignore and some other `.*ignore` files",
      "version": "1.0",
      "mod_version": "3",
      "remote": "https://github.com/anthonyaxenov/lite-xl-ignore-syntax:2ed993ed4376e1840b0824d7619f2d3447891d3aa234459378fcf9387c4e4680", # The remote to be used for this plugin.
      "id": "language_ignore",
      "post": {"x86-linux":"cp language_ignore.lua /tmp/somewhere-else", "x86-windows":"COPY language_ignore.lua C:\\Users\\Someone\\ignore.lua"} # Post download steps to run to fully set up the plugin. Does not run by default, requires --post.
    },
    {
      "description": "Provides a GUI to manage core and plugin settings, bindings and select color theme. Depends on widget.",
      "dependencies": {
        "toolbarview": { "version": ">=1.0" },
        "widget": { "version": ">=1.0" }
      },
      "version": "1.0",
      "mod_version": "3",
      "path": "plugins/settings.lua",
      "id": "settings"
    },
    {
      "description": "Syntax for Kaitai struct files",
      "url": "https://raw.githubusercontent.com/whiteh0le/lite-plugins/main/plugins/language_ksy.lua?raw=1", # URL directly to the singleton plugin file.
      "id": "language_ksy",
      "version": "1.0",
      "mod_version": "3",
      "checksum": "08a9f8635b09a98cec9dfca8bb65f24fd7b6585c7e8308773e7ddff9a3e5a60f", # Checksum for this particular URL.
    }
  ],
  "lite-xls": [ # An array of lite-xl releases.
    {
      "version": "2.1-simplified", # The version, followed by a release suffix defining the release flavour. The only releases that are permitted to not have suffixes are official relases.
      "mod_version": "3", # The mod_version this release corresponds to.
      "files": [ # Identical to `files` under `addons`, although these are usually simply archives to be extracted.
        {
          "arch": "x86_64-linux",
          "url": "https://github.com/adamharrison/lite-xl-simplified/releases/download/v2.1/lite-xl-2.1.0-simplified-x86_64-linux.tar.gz",
          "checksum": "b5087bd03fb491c9424485ba5cb16fe3bb0a6473fdc801704e43f82cdf960448"
        },
        {
          "arch": "x86_64-windows",
          "url": "https://github.com/adamharrison/lite-xl-simplified/releases/download/v2.1/lite-xl-2.1.0-simplified-x86_64-windows.zip",
          "checksum": "f12cc1c172299dd25575ae1b7473599a21431f9c4e14e73b271ff1429913275d"
        }
      ]
    },
    {
      "version": "2.1-simplified-enhanced",
      "mod_version": "3",
      "files": [
        {
          "arch": "x86_64-linux",
          "url": "https://github.com/adamharrison/lite-xl-simplified/releases/download/v2.1/lite-xl-2.1.0-simplified-x86_64-linux-enhanced.tar.gz",
          "checksum": "4625c7aac70a2834ef5ce5ba501af2d72d203441303e56147dcf8bcc4b889e40"
        },
        {
          "arch": "x86_64-windows",
          "url": "https://github.com/adamharrison/lite-xl-simplified/releases/download/v2.1/lite-xl-2.1.0-simplified-x86_64-windows-enhanced.zip",
          "checksum": "5ac009e3d5a5c99ca7fbd4f6b5bd4e25612909bf59c0925eddb41fe294ce28a4"
        }
      ]
    }
  ],
  "remotes": [ # A list of remote specifiers. The plugin manager will pull these in and add them as additional repositories if specified to do so with a flag.
    "https://github.com/lite-xl/lite-xl-plugins.git:2.1",
    "https://github.com/adamharrison/lite-xl-simplified.git:v2.1"
  ]
}
]]

ptm.add_template() {
  name = "(single)lpm-manifest",
  desc = "A complete lpm manifest for Lite XL plugins.",
  files = {
    ["manifest.json"] = {
      content = content,
      path = ""
    }
  },
  dirs = {},
  ext_libs = {},
  lsp_config_files = {},
  commands = {}
}
