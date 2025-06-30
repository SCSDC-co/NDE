# 🚀 OptiSpec - Smart Language Management System

**OptiSpec** is an intelligent language management system built into NDE that provides zero-bloat, on-demand installation of development tools.

## ✨ What is OptiSpec?

OptiSpec is a **complete language management system** that revolutionizes development tool handling:

- **🎯 Zero-Bloat Start**: Starts with no tools installed - completely clean
- **📦 Smart Installation**: Install language tools only when you need them
- **⚡ Auto-Detection**: Automatically detects file types and prompts for tools
- **🔄 Easy Management**: Install, remove, and update tools with simple commands
- **🧠 Smart Diagnostics**: Merges LSP and linter diagnostics intelligently (NEW!)
- **🎨 Beautiful UI**: NUI-powered interface with modern design
- **🎮 NDE Integration**: Fully integrated with the NDE command suite

## 📁 System Structure

```
lua/optispec/
├── init.lua              # Main setup and API
├── core/                 # Core functionality
│   ├── diagnostics.lua   # Smart diagnostic merging
│   ├── installer.lua     # Language tool installer
│   ├── languages.lua     # Language detection
│   ├── lsp.lua           # LSP management
│   ├── formatters.lua    # Formatter integration
│   ├── linters.lua       # Linter integration
│   └── mason.lua         # Mason integration
├── ui/                   # NUI-based interfaces
│   ├── browser.lua       # Language browser GUI
│   ├── status.lua        # Status dashboard
│   └── prompt.lua        # Installation prompts
└── languages/            # Language configurations
    ├── web.lua           # Web development
    ├── systems.lua       # Systems programming
    ├── scripting.lua     # Scripting languages
    └── ...               # Other language groups
```

## 🎮 Usage (NDE Integration)

OptiSpec is fully integrated with the NDE command suite for easy access:

### Main Commands

```vim
:NDE optispec                 " Show OptiSpec help and features
:NDE optispec status          " Show installed languages and tools
:NDE optispec browse          " Open beautiful language browser GUI
:NDE optispec install <lang>  " Install tools for a language
:NDE optispec remove <lang>   " Remove language tools
:NDE optispec update          " Update all installed tools
```

### Quick Access

- **Dashboard**: Press `g` on the NDE dashboard to open OptiSpec browser
- **Tab Completion**: All commands support intelligent tab completion
- **Language Detection**: OptiSpec automatically prompts when opening new file types

## 🎯 How It Works

### Smart Workflow

1. **Open a Python file** → OptiSpec detects Python
2. **Beautiful prompt appears**: "Install Python development tools?"
3. **Choose Yes** → Installs LSP, formatters, linters, debugger, treesitter
4. **Tools are ready** for all future Python files
5. **Smart merging** → LSP and linter diagnostics are intelligently merged (no duplicates!)

### Example Workflow

```bash
# Open a new project
nvim my_project/

# Files trigger smart prompts:
├── main.py          # → "Install Python tools?"
├── script.js        # → "Install JavaScript tools?"
├── config.yaml      # → "Install YAML tools?"
└── README.md        # → "Install Markdown tools?"

# Or use NDE commands directly:
:NDE optispec browse          # Browse all available languages
:NDE optispec install rust    # Install Rust development tools
:NDE optispec status          # See what's installed
```

## 🛠️ Supported Languages

OptiSpec supports **50+ languages** out of the box:

### Popular Languages
- **Python** - pyright, black, flake8, debugpy
- **JavaScript/TypeScript** - tsserver, prettier, eslint, debugging
- **Rust** - rust-analyzer, rustfmt, cargo integration
- **Go** - gopls, gofmt, delve debugger
- **C/C++** - clangd, clang-format, GDB debugging
- **Java** - jdtls, google-java-format, debugging

### Web Development
- **HTML/CSS** - Language servers, prettier formatting
- **React/Vue/Svelte** - Full framework support
- **Angular** - Complete development stack

### And Many More!
Lua, Shell, YAML, JSON, TOML, Markdown, Docker, Terraform, Ansible, Clojure, Elixir, Elm, Erlang, Haskell, Kotlin, OCaml, PHP, Ruby, Scala, SQL, and more!

## 🎮 Commands (NDE Integration)

```vim
" Main OptiSpec commands through NDE suite:
:NDE optispec                  " Show OptiSpec help and features
:NDE optispec status           " Show installed languages and tools
:NDE optispec browse           " Open beautiful language browser GUI
:NDE optispec install <lang>   " Install tools for a language
:NDE optispec remove <lang>    " Remove language tools
:NDE optispec update           " Update all installed tools

" Tab completion support:
:NDE optispec install <TAB>    " Shows available languages
:NDE optispec remove <TAB>     " Shows installed languages
```

## ⚙️ Configuration

OptiSpec is pre-configured in **NDE**, but you can customize it by editing `lua/optispec/init.lua`:

### Default Configuration

```lua
-- Configuration is in lua/optispec/init.lua
local default_config = {
  -- Languages to install immediately (optional)
  languages = {},
  
  -- Prompt settings
  prompt = {
    enabled = true,        -- Show prompts for new languages
    auto_install = false,  -- Ask before installing
  },
  
  -- Tool integration
  tools = {
    mason = { auto_update = true },
    lsp = { auto_attach = true },
    diagnostics = { merge_sources = true },  -- Smart diagnostic merging!
  },
}
```

### Customizing Languages

To pre-install specific languages, edit `lua/launch.lua`:

```lua
-- In lua/launch.lua, find the optispec setup:
require('optispec').setup({
  -- Pre-install essential languages
  languages = { "lua", "markdown", "json", "yaml" },
  prompt = { enabled = true }
})
```

## 💡 Key Features

### 🧠 Smart Diagnostic Merging (NEW!)

OptiSpec features an advanced diagnostic merging system that eliminates duplicate diagnostics:

```lua
-- BEFORE: 3 duplicate "unused variable" diagnostics   😤
-- AFTER:  1 clean diagnostic (LSP takes priority)     😎

-- Same diagnostic from LSP and linter?
-- → Shows only LSP version (higher priority)

-- Different diagnostics on same line?
-- → Shows both (they provide different info)

-- Similar messages ("unused variable" vs "'var' is unused")?
-- → Merges intelligently, keeps the better one
```

**How it works:**
- Intercepts all diagnostics at the `vim.diagnostic.set` level
- Compares diagnostics for similarity (position, severity, message)
- Prioritizes LSP diagnostics over linter diagnostics
- Merges results into a single clean namespace
- **No more seeing 3 of the same diagnostic!** 🎉

### 🎨 Beautiful UI & NDE Integration

- **NDE Command Suite**: Fully integrated with `:NDE optispec` commands
- **Dashboard Integration**: Press `g` on dashboard to open language browser
- **Tab Completion**: Intelligent completion for all commands
- **Modern Interface**: Clean, responsive UI built with NUI
- **Interactive Prompts**: Beautiful installation dialogs
- **Language Browser**: Visual language selection with search (`:NDE optispec browse`)
- **Status Dashboard**: Real-time overview of installed tools (`:NDE optispec status`)
- **Progress Indicators**: Live installation progress

### ⚡ Zero-Bloat Performance

- **Lazy Loading**: Tools are only loaded when needed
- **Fast Startup**: No impact on Neovim startup time
- **Smart Caching**: Efficient tool management
- **On-Demand Prompts**: Only show when necessary

## 🔧 Adding New Languages

OptiSpec is designed to make adding languages super easy!

### Basic Language Config

Add a new language to the appropriate group file in `lua/optispec/languages/`:

```lua
-- In lua/optispec/languages/scripting.lua (for example)

-- Add to the languages table:
newlang = {
  name = "NewLang",
  icon = "🆕",
  category = "scripting",
  
  -- Mason tools to install
  mason_tools = {
    lsp = { "newlang-lsp" },
    formatters = { "newlang-fmt" },
    linters = { "newlang-lint" },
    dap = { "newlang-debug" },
  },
  
  -- LSP configuration
  lsp = {
    { 
      name = "newlang_lsp",
      settings = {
        newlang = {
          -- LSP settings
        }
      }
    }
  },
  
  -- Treesitter parsers
  treesitter = { "newlang" },
  
  -- File types
  filetypes = { "newlang" },
},
```

### Language Groups

Organize languages by category:
- `web.lua` - Web development (JS, TS, React, Vue, etc.)
- `systems.lua` - Systems programming (Rust, Go, C++, etc.)
- `scripting.lua` - Scripting languages (Python, Ruby, etc.)
- `functional.lua` - Functional languages (Haskell, Elixir, etc.)
- `data.lua` - Data languages (SQL, R, etc.)
- `devops.lua` - DevOps tools (Docker, Terraform, etc.)

### That's it! 

OptiSpec will automatically:
- Add the language to the browser GUI
- Enable auto-detection for the filetypes
- Set up smart diagnostic merging
- Handle all tool installation and configuration

## 🎯 Philosophy

OptiSpec follows these principles:

1. **Zero Bloat**: Start clean, add only what you use
2. **Smart Defaults**: Use the best tools with minimal config
3. **Easy Extension**: Adding languages should be trivial
4. **Performance First**: Never impact startup time
5. **User Choice**: Always ask before installing
6. **Smart Merging**: Eliminate diagnostic duplicates intelligently
7. **NDE Integration**: Seamlessly integrated with the command suite

## 🚀 Getting Started

1. **Open any file** - OptiSpec will auto-detect and prompt for tools
2. **Use the browser** - `:NDE optispec browse` for visual language selection
3. **Check status** - `:NDE optispec status` to see what's installed
4. **Install manually** - `:NDE optispec install python` for specific languages
5. **Enjoy smart diagnostics** - No more duplicate diagnostics! 🎉

## 🙏 Part of NDE

OptiSpec is a core component of the **Neovim Development Environment (NDE)**.

Built with ❤️ for developers who want:
- Zero configuration overhead
- Smart, clean development tools
- Beautiful, intuitive interfaces
- Performance that doesn't compromise
- No more duplicate diagnostics!

---

**🚀 Experience the future of Neovim language management!**

*OptiSpec: Zero-bloat, smart diagnostics, beautiful UI - all integrated with NDE.*
