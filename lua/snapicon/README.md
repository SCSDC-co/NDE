# 📸 SnapIcon

A modular NDE (Neovim Development Environment) plugin for taking beautiful code screenshots using Silicon.

_Part of the NDE ecosystem - enhancing your Neovim development experience!_

## Features

- 🎨 **Configurable themes and styling** - Customize background, theme, font, and padding
- 📁 **Flexible output options** - Custom filename templates and output directories
- 🔧 **Modular architecture** - Clean separation of concerns with configurable components
- ⌨️ **Customizable keybindings** - Set your own shortcuts for taking screenshots
- 🪟 **Window title options** - Show full file path or just filename in screenshot
- 🌈 **Language detection** - Automatic syntax highlighting based on file extension
- 📋 **Visual selection support** - Screenshot only the selected code
- 📋 **Clipboard integration** - Automatically copies screenshots to clipboard (Linux)

## Requirements

- [Silicon](https://github.com/Aloxaf/silicon) - Must be installed and available in PATH
- Neovim 0.8+ (for `vim.notify` and modern Lua features)

## Installation

SnapIcon is integrated into NDE and loads automatically when you open files. The configuration is handled in your `launch.lua` file:

```lua
-- In your launch.lua file (already configured)
require("snapicon").setup({
    -- Your configuration here (optional)
})
```

## Configuration

### Default Configuration

```lua
require("snapicon").setup({
    -- Screenshot settings
    silicon = {
        background = "#181616",
        theme = "Visual Studio Dark+",
        font = "FiraCode Nerd Font Mono=34",
        pad_vert = 80,
        pad_horiz = 50,
        show_window_controls = true,
    },

    -- Output settings
    output = {
        dir = nil, -- nil means use XDG_PICTURES_DIR or ~/Pictures
        filename_template = "silicon-{timestamp}.png", -- {timestamp}, {filename}, {filepath}
        use_full_path_title = true, -- Show full path in window title
        copy_to_clipboard = true, -- Copy screenshot to clipboard (Linux only)
    },

    -- Keybindings
    keymaps = {
        take_screenshot = "<leader>S",
    },

    -- Command settings
    command = {
        name = "Silicon",
        range = true,
    },

    -- Which-key integration
    which_key = {
        enabled = true,
        group_key = "<leader>C",
        group_name = "📸 Silicon",
    },
})
```

### Configuration Options

#### Silicon Settings (`silicon`)

- `background` (string): Background color for the screenshot
- `theme` (string): Syntax highlighting theme
- `font` (string): Font family and size
- `pad_vert` (number): Vertical padding in pixels
- `pad_horiz` (number): Horizontal padding in pixels
- `show_window_controls` (boolean): Show macOS-style window controls

#### Output Settings (`output`)

- `dir` (string|nil): Custom output directory (nil uses system default)
- `filename_template` (string): Template for filename generation
    - `{timestamp}`: Current timestamp (YYYY-MM-DD-HHMMSS)
    - `{filename}`: Current file name
    - `{filepath}`: Full file path (slashes replaced with underscores)
- `use_full_path_title` (boolean): Show full path vs filename in window title
- `copy_to_clipboard` (boolean): Copy screenshot to clipboard (Linux only, requires xclip)

#### Keymaps (`keymaps`)

- `take_screenshot` (string): Key combination to take screenshot

#### Command Settings (`command`)

- `name` (string): Name of the Neovim command
- `range` (boolean): Whether the command supports range selection

#### Which-key Integration (`which_key`)

- `enabled` (boolean): Enable which-key integration
- `group_key` (string): Key for the which-key group
- `group_name` (string): Display name for the which-key group

## Usage

### Taking Screenshots

1. **Visual Selection**: Select code in visual mode (`v` or `V`)
2. **Take Screenshot**: Press `<leader>S` (or your configured keybinding)
3. **Alternative**: Use the `:Silicon` command

### Example Configurations

#### Minimal Setup

```lua
require("snapicon").setup()
```

#### Custom Styling

```lua
require("snapicon").setup({
    silicon = {
        background = "#2d3748",
        theme = "Dracula",
        font = "JetBrains Mono=32",
        pad_vert = 60,
        pad_horiz = 40,
    },
    keymaps = {
        take_screenshot = "<leader>cs",
    },
})
```

#### Custom Output

```lua
require("snapicon").setup({
    output = {
        dir = "/home/user/screenshots",
        filename_template = "code-{filename}-{timestamp}.png",
        use_full_path_title = false,
    },
})
```

## Architecture

The plugin follows a modular architecture:

```
lua/snapicon/
├── init.lua          # Main module with setup function
├── core.lua          # Core screenshot functionality
├── keymaps.lua       # Keybinding setup
├── commands.lua      # Neovim command setup
├── which_key.lua     # Which-key integration
└── README.md         # This file
```

### Modules

- **`init.lua`**: Main entry point with configuration management
- **`core.lua`**: Core screenshot logic, Silicon command building, and file handling
- **`keymaps.lua`**: Keybinding registration and management
- **`commands.lua`**: Neovim command creation
- **`which_key.lua`**: Which-key integration for better discoverability

## NDE Integration

SnapIcon is seamlessly integrated into the NDE ecosystem:

- **Auto-loading**: Automatically loads when you open files
- **NDE Commands**: Integrates with the NDE command system
- **Configuration**: Managed through NDE's configuration pattern
- **Notifications**: Uses NDE's notification system for feedback

### NDE Command Integration

SnapIcon integrates with NDE's command suite pattern. You can access it through:

```
:NDE snapicon config   # Show current configuration
:NDE snapicon help     # Show help
:NDE snapicon          # Show all snapicon commands
```

## API

### Public Functions

- `require("snapicon").setup(opts)`: Initialize the plugin with configuration
- `require("snapicon").take_screenshot()`: Take a screenshot programmatically
- `require("snapicon").get_config()`: Get current configuration

## Troubleshooting

1. **Silicon not found**: Ensure Silicon is installed and in your PATH
2. **Screenshots not saving**: Check that the output directory exists and is writable
3. **Font not working**: Ensure the specified font is installed on your system
4. **Theme not applying**: Check that the theme name is valid for your Silicon installation

## Contributing

This is a local plugin, but you can:

1. Fork the code for your own modifications
2. Share configurations and improvements
3. Report issues or suggest features

## License

SnapIcon is part of the NDE (Neovim Development Environment) ecosystem and follows the same licensing as your NDE configuration.
