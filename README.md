# NVIM Configuration

This repository contains a comprehensive configuration setup for [Neovim (NVIM)](https://neovim.io/), aimed at enhancing the editor's functionality and user experience. The configuration is designed to provide a modern, efficient, and highly customizable development environment.

## Features

- Modular and organized configuration files
- Plugin management with [lazy.vim](https://github.com/folke/lazy.nvim)
- Enhanced user interface with themes and status lines
- Support for multiple programming languages with syntax highlighting and language servers
- Custom key mappings to streamline workflow
- Integration of useful development tools and utilities

## Installation

### Prerequisites

- Neovim (version 0.5 or higher)
- Git
  
### Steps

1. Clone this repository to your local machine:
   
   - ```git clone https://github.com/Sckab/NVIM-configuration.git ~/.config/nvim```

2. Launch Neovim to automatically install the plugins
3. Within Neovim, run the following command to sync the plugins:
   
   - `:Lazy sync`

## Usage

Once installed, the configuration will automatically load each time you start Neovim. You can customize further by editing the configuration files located in the `~/.config/nvim` directory.

## Configuration Structure

- `init.vim`: Main entry point for the configuration
- `launch.vim`: Load all the needed files
- `opts.vim`: General editor settings
- `keymaps.vim`: Custom key mappings
- `lazy.lua`: PLugin setup
- Other modular files organizing specific configurations

This is the file structure

```
~/.config/nvim/
│
├── init.lua
└── lua
     ├── lazynvim/
     │      └── lazy.lua 
     ├── GUI/
     │      └── theme.lua
     ├── opts.lua
     ├── keymaps.lua
     ├── launch.lua
     └── plugins/
            ├── autopairs.lua
            ├── bufferline.lua
            ├── cmp.lua
            ├── lsp.lua
            ├── lualine.lua
            ├── neotree.lua
            ├── telescope.lua
            ├── dashboard.lua
            ├── indent-blankline.lua
            ├── toggleterm.lua
            └── treesitter.lua
```

## Contributing

Contributions and suggestions are welcome. Feel free to open issues or submit pull requests to improve the configuration.

## License

This project is licensed under the [MIT License](LICENSE).

---

*For detailed information and updates, please visit the original repository:*  
[https://github.com/Sckab/NVIM-configuration](https://github.com/Sckab/NVIM-configuration)
