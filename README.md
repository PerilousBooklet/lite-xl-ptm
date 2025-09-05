# Project Template Manager

![ptm-1](https://github.com/user-attachments/assets/9526106f-0a50-455a-ac15-0f6b2c9f6b45)

![ptm-2](https://github.com/user-attachments/assets/34b26daa-e4e5-4332-a8aa-9ebdeaf8c1a8)

A project template manager plugin for Lite XL.

> [!NOTE]
> At the moment this plugin is LINUX ONLY.

## Quickstart

To begin with, you'll need the [Lite XL package manager](https://github.com/lite-xl/lite-xl-plugin-manager?tab=readme-ov-file#installing).

Then open the integrated terminal and run `lpm install ptm`.

After that, write the following into `~/.config/lite-xl/init.lua`:

```lua
local ptm = require "plugins.ptm"
ptm.load()
```

## Documentation

`ptm` can generate folder/file structures for single files and complex project templates.

Single-file templates follow the naming convention `(single)project_template_name`.

Complex project templates do not require any name prefix, thus `project_template_name`.

Here's the [reference template](https://github.com/PerilousBooklet/lite-xl-ptm/blob/main/templates/example.lua)
