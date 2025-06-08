# Neovim Development Environment

A comprehensive, production-ready Neovim configuration featuring automated cross-platform installation and complete development toolchain integration. This configuration provides a modern, efficient development environment with minimal setup requirements.

[![Platform Support](https://img.shields.io/badge/Platform-Linux%20%7C%20macOS%20%7C%20Windows-blue)](#platform-support)
[![Neovim Version](https://img.shields.io/badge/Neovim-0.10.0+-green)](#requirements)
[![Auto Install](https://img.shields.io/badge/Installation-Automated-brightgreen)](#installation)
[![Languages](https://img.shields.io/badge/Languages-9+-orange)](#language-support)
[![License](https://img.shields.io/badge/License-MIT-blue)](#license)

## Features

### Automated Installation
- Cross-platform automated setup script
- Intelligent package manager detection (apt, pacman, dnf, brew, chocolatey, winget)
- Automatic Neovim 0.10+ installation with repository management
- Optional terminal emulator configuration (Kitty with Kanagawa theme)
- Comprehensive dependency resolution

### Development Toolchain
**Language Servers:** Python (Pyright), JavaScript/TypeScript, C/C++ (Clangd), C# (OmniSharp), Lua, Assembly, HTML, CSS  
**Code Formatters:** Black, Prettier, Clang-format, asmfmt  
**Linters:** Flake8, ESLint, Clang-tidy, Stylelint, Luacheck, HTML Tidy  
**Debuggers:** GDB, LLDB, Python DAP, C++ DAP, JavaScript DAP  
**Development Utilities:** Ripgrep, fd-find, Lazygit, Tree, jq  

### User Interface
- Kanagawa Dragon color scheme
- Enhanced file navigation with Telescope and Neo-tree
- Intelligent auto-completion via nvim-cmp
- Advanced syntax highlighting through Treesitter
- Integrated terminal management with ToggleTerm
- Git integration with Gitsigns
- Customizable status line with Lualine
- Buffer management with Bufferline

### Advanced Capabilities
- Language Server Protocol (LSP) integration
- Debug Adapter Protocol (DAP) support
- Automatic code formatting on save
- Plugin management via Lazy.nvim
- Mason-based tool installation
- Custom keybinding configurations

## Installation

### Requirements
- **Neovim 0.10.0 or higher** (automatically installed by script)
- Git
- Internet connection for downloading dependencies

### Automated Setup (Recommended)

```bash
# Clone the repository
git clone https://github.com/Sckab/NVIM-configuration.git ~/.config/nvim

# Execute the installation script
cd ~/.config/nvim
chmod +x main.sh
./main.sh
```

The installation script performs the following operations:

1. **System Analysis**: Detects platform and package manager
2. **Neovim Installation**: Ensures Neovim 0.10+ is installed
3. **Dependency Resolution**: Installs all required development tools
4. **Language Server Setup**: Configures LSP servers for supported languages
5. **Tool Installation**: Installs formatters, linters, and debuggers
6. **Terminal Configuration**: Optional Kitty terminal setup
7. **Font Installation**: Nerd Font installation for enhanced UI

### Manual Installation

For users preferring manual dependency management:

**Prerequisites:**
- Neovim 0.10.0 or higher
- Git
- Node.js and npm
- Python 3 and pip
- A Nerd Font

**Installation steps:**
```bash
git clone https://github.com/Sckab/NVIM-configuration.git ~/.config/nvim
nvim  # Launch Neovim to trigger plugin installation
```

**Plugin synchronization:**
```vim
:Lazy sync
```

> **Note:** Manual installation requires careful attention to Neovim version compatibility. The automated script handles version requirements automatically.

## Installed Components

### Core Development Environment
| Component | Purpose | Installation Method |
|-----------|---------|--------------------|
| Neovim 0.10+ | Editor platform | Package manager + repository setup |
| Node.js & npm | JavaScript ecosystem & language servers | Package manager |
| Python 3 & pip | Python development & tools | Package manager |
| .NET SDK | C# development | Package manager / Microsoft repository |
| Rust toolchain | Rust development & tools | rustup installer |
| Go | Additional language server dependencies | Package manager |

### Development Tools & Utilities
| Category | Tools | Description |
|----------|-------|-------------|
| **Search & Navigation** | Ripgrep, fd-find, Tree | High-performance file search and navigation |
| **Version Control** | Git, Lazygit | Source control and terminal UI |
| **Utilities** | jq, curl | JSON processing and data transfer |

### Language Support Infrastructure
| Component Type | Tools | Languages Supported |
|----------------|-------|--------------------|
| **Language Servers** | Pyright, ts_ls, Clangd, OmniSharp, lua_ls, asm_lsp, html, cssls, bash-language-server | Python, JavaScript/TypeScript, C/C++, C#, Lua, Assembly, HTML, CSS, Bash |
| **Code Formatters** | Black, Prettier, Clang-format, asmfmt | Python, Web technologies, C/C++, Assembly |
| **Linters** | Flake8, ESLint, Clang-tidy, Stylelint, Luacheck, HTML Tidy | Python, JavaScript/TypeScript, C/C++, CSS, Lua, HTML |
| **Debuggers** | GDB, LLDB, debugpy, cppdbg, js-debug-adapter | C/C++, Python, JavaScript/TypeScript |

### User Interface Components
| Component | Description | Configuration |
|-----------|-------------|---------------|
| **Terminal Emulator** | Kitty (optional) | Kanagawa theme integration |
| **Fonts** | Nerd Fonts | FiraCode or JetBrainsMono options |
| **Color Scheme** | Kanagawa Dragon | Consistent theming across components |

## Platform Support

| Platform | Package Managers | Neovim Repository | Status |
|----------|------------------|-------------------|--------|
| **Linux** | apt, pacman, dnf, zypper, emerge | PPA/COPR auto-setup | Full Support |
| **macOS** | Homebrew, MacPorts | Official repositories | Full Support |
| **Windows** | Chocolatey, winget | Official repositories | Full Support |
| **WSL** | Linux package managers | PPA/COPR auto-setup | Full Support |

## Language Support

| Language | LSP Server | Code Formatter | Linter | Debugger | Status |
|----------|------------|----------------|--------|----------|--------|
| **Python** | Pyright | Black | Flake8 | debugpy | Complete |
| **JavaScript/TypeScript** | ts_ls | Prettier | ESLint | js-debug-adapter | Complete |
| **C/C++** | Clangd | clang-format | clang-tidy | GDB/LLDB | Complete |
| **C#** | OmniSharp | dotnet format | - | cppdbg | Partial |
| **Lua** | lua_ls | - | luacheck | - | Partial |
| **HTML** | html | Prettier | HTML Tidy | - | Partial |
| **CSS** | cssls | Prettier | stylelint | - | Partial |
| **Assembly** | asm_lsp | asmfmt | - | GDB | Partial |
| **Bash** | bash-language-server | - | - | - | Basic |

## Configuration Architecture

```
~/.config/nvim/
├── 📄 installation.sh          # 🚀 Automated installation script
├── 📄 init.lua                 # Entry point
├── 📄 lazy-lock.json           # Plugin lockfile
├── 📄 LICENSE                  # MIT License
├── 📄 README.md                # This file
└── 📁 lua/
    ├── 📁 GUI/
    │   └── 📄 theme.lua         # 🎨 Kanagawa theme configuration
    ├── 📄 keymaps.lua           # ⌨️  Custom key mappings
    ├── 📄 launch.lua            # 🚀 Plugin loader
    ├── 📄 opts.lua              # ⚙️  Editor options
    ├── 📁 lazynvim/
    │   └── 📄 lazy.lua          # 📦 Lazy.nvim setup
    └── 📁 plugins/
        ├── 📄 autoformat.lua    # 🔧 Auto-formatting
        ├── 📄 autopairs.lua     # () Auto-pairs
        ├── 📄 bufferline.lua    # 📑 Buffer tabs
        ├── 📄 cmp.lua           # 🔤 Auto-completion
        ├── 📄 codeium.lua       # 🤖 AI completion
        ├── 📄 dap.lua           # 🐛 Debug adapters
        ├── 📄 dashboard.lua     # 📊 Start screen
        ├── 📄 debug.lua         # 🐛 Debug configuration
        ├── 📄 gitsigns.lua      # 📝 Git integration
        ├── 📄 indent-blankline.lua # ┊ Indent guides
        ├── 📄 lint.lua          # 🔍 Linting
        ├── 📄 lualine.lua       # 📊 Status line
        ├── 📄 mason.lua         # 🔨 LSP installer
        ├── 📄 neotree.lua       # 🌲 File explorer
        ├── 📄 noice.lua         # 💬 Better UI
        ├── 📄 scrollview.lua    # 📜 Scroll indicator
        ├── 📄 telescope.lua     # 🔭 Fuzzy finder
        ├── 📄 toggleterm.lua    # 💻 Terminal integration
        └── 📄 treesitter.lua    # 🌳 Syntax highlighting
```

## Usage

### Initial Setup
Launch Neovim to complete the configuration:
```bash
nvim
```

The system will automatically:
1. Install all configured plugins via Lazy.nvim
2. Initialize language servers through Mason
3. Apply the Kanagawa theme configuration
4. Prepare the development environment

### Key Bindings
| Keybinding | Function | Description |
|------------|----------|-------------|
| `<leader>ff` | File Search | Search files using Telescope |
| `<leader>fg` | Content Search | Live grep in files |
| `<leader>fb` | Buffer List | Display open buffers |
| `<leader>fh` | Help Search | Search help documentation |
| `<leader>f` | Format Code | Format current file |
| `<F12>` | Terminal Toggle | Toggle vertical terminal |
| `<F11>` | Git Interface | Open Lazygit TUI |
| `<C-Space>` | Completion | Trigger auto-completion |
| `<CR>` | Accept | Accept completion suggestion |

### Administrative Commands
| Command | Purpose | Usage |
|---------|---------|-------|
| `:Lazy` | Plugin Management | Install, update, and manage plugins |
| `:Mason` | LSP Management | Install and configure language servers |
| `:Telescope` | Fuzzy Finder | Advanced file and content search |
| `:Neotree` | File Explorer | Navigate project structure |
| `:Autoformat` | Code Formatting | Format current buffer |

## Customization

### Adding Language Support
To add support for additional programming languages:

1. **Language Server Configuration**: Edit `lua/plugins/mason.lua`
2. **Code Formatting**: Configure formatters in `lua/plugins/autoformat.lua`
3. **Linting Rules**: Add linter configuration to `lua/plugins/lint.lua`
4. **Debug Adapters**: Configure debuggers in `lua/plugins/debug.lua`

### Theme Customization
Modify visual appearance by editing `lua/GUI/theme.lua`. This file contains color scheme definitions and UI styling configuration.

### Keybinding Customization
Custom keybindings can be added to `lua/keymaps.lua`. Follow the existing pattern for consistency.

### Plugin Configuration
Individual plugin configurations are modularized in `lua/plugins/`. Each file corresponds to a specific plugin or feature set.

## Troubleshooting

### Neovim Version Compatibility
```bash
# Check Neovim version
nvim --version

# If version is below 0.10.0, re-run the installation script
cd ~/.config/nvim && ./installation.sh

# For Ubuntu/Debian, the script automatically adds the unstable PPA:
# sudo add-apt-repository ppa:neovim-ppa/unstable
```

### Installation Problems
```bash
# Check installation log
tail -f /tmp/nvim-setup-*.log

# Re-run installation
cd ~/.config/nvim && ./installation.sh
```

### Plugin Management Issues
```vim
" In Neovim, reset plugins
:Lazy clean
:Lazy sync

" Reset language servers
:Mason
:MasonUninstallAll
:MasonInstall pyright typescript-language-server
```

### Dependency Resolution
The installation script handles most dependencies, but if something is missing:
```bash
# Check what's installed
which nvim node python3 git rg fd

# Re-run dependency installation
cd ~/.config/nvim && ./installation.sh
```

### Manual Neovim Installation
If the automatic installation fails, you can install manually:

**Ubuntu/Debian:**
```bash
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install neovim
```

**Fedora:**
```bash
sudo dnf copr enable agriffis/neovim-nightly
sudo dnf install neovim
```

**Arch Linux:**
```bash
sudo pacman -S neovim  # Usually has latest version
```

## Contributing

Contributions are welcome! Here's how:

1. 🍴 Fork the repository
2. 🌟 Create a feature branch
3. 💡 Make your improvements
4. 🧪 Test thoroughly
5. 📤 Submit a pull request

### Development Areas
- Platform support expansion
- Language configuration additions
- User interface enhancements
- Documentation improvements
- Bug fixes and performance optimizations

## License

This project is licensed under the [MIT License](LICENSE).

## Acknowledgments

- [Neovim](https://neovim.io/) - The editor that makes this possible
- [Lazy.nvim](https://github.com/folke/lazy.nvim) - Amazing plugin manager
- [Kanagawa](https://github.com/rebelot/kanagawa.nvim) - Beautiful color scheme
- [Mason](https://github.com/williamboman/mason.nvim) - Language server installer
- All the plugin authors who make Neovim amazing

> ⚠️ **Note:** If the installer fails to install certain dependencies or packages, please install them manually using your system's package manager or by following the official documentation for each tool.

---

<div align="center">

**Please consider starring this repository if you find it useful.**

*For detailed information and updates, visit:*  
[https://github.com/Sckab/NVIM-configuration](https://github.com/Sckab/NVIM-configuration)

</div>
