# Project Template Manager

![ptm-1](https://github.com/user-attachments/assets/9526106f-0a50-455a-ac15-0f6b2c9f6b45)

![ptm-2](https://github.com/user-attachments/assets/34b26daa-e4e5-4332-a8aa-9ebdeaf8c1a8)

A project template manager plugin for Lite XL.

> [!NOTE]
> At the moment this plugin is LINUX ONLY.

> [!WARNING]
> At the moment the functionality for downloading dependencies is broken, a FIX is WIP.

## How to install

Install the [Lite XL package manager](https://github.com/lite-xl/lite-xl-plugin-manager?tab=readme-ov-file#installing).

Run `lpm install ptm`.

Load the template modules into Lite XL: 

> `~/.config/lite-xl/init.lua`

```lua
local ptm = require "plugins.ptm"
ptm.load()
```

## Documentation

<!-- TODO: write docs for how functions work -->
You can find the documentation [here](./DOCS.md)
