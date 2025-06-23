# 🚀 NDE Command Suite v2.2.0

> **N**eovim **D**evelopment **E**nvironment - Your complete coding companion!

## 🌟 What is NDE?

NDE is a powerful, feature-rich Neovim configuration that transforms your editor into a complete development environment. With intelligent tips, dynamic loading, and a comprehensive command suite, NDE makes coding both productive and fun!

## 🎯 Command Suite Overview

The NDE Command Suite provides a centralized interface to control all NDE features through the `:NDE` command. Everything you need is just a command away!

### 🚀 Quick Start

```vim
:NDE help    " Show all available commands
:NDE tips on " Enable the tips system
:NDE status  " Check NDE status
```

## 💡 Tips System

Get helpful Neovim tips and tricks automatically displayed while you code!

### Commands

| Command           | Description            |
|-------------------|------------------------|
| `:NDE tips on`    | Enable automatic tips  |
| `:NDE tips off`   | Disable automatic tips |
| `:NDE tips`       | Toggle tips on/off     |
| `:NDE tip show`   | Show current tip       |
| `:NDE tip next`   | Show next tip          |
| `:NDE tip random` | Show random tip        |

### Features

- 🎯 **Smart Timing**: Tips appear every 45 seconds when you're actively coding
- 🧠 **Context Aware**: Only shows tips in actual files (not terminals, help, etc.)
- 💾 **Persistent Settings**: Your tip preferences are saved between sessions
- 🎨 **Beautiful Display**: Fun emojis and engaging messages
- 🎲 **Variety**: 8 different tip categories with multiple tips each

### Tip Categories

1. 🚀 **Navigation Basics** - Essential movement commands
2. 📁 **File Operations** - Save, quit, find files
3. ⚡ **Editing Power** - Cut, copy, paste, undo/redo
4. 🧭 **Code Navigation** - Go to definition, references, hover
5. 🪟 **Window Management** - Splits and window navigation
6. 💻 **Terminal & Tasks** - Terminal integration
7. 🎨 **Pro Tips** - Advanced editing tricks
8. 🚀 **Advanced Moves** - Text objects and power commands

## 🔧 Dynamic Loader System

NDE features an intelligent dynamic loader that optimizes performance and provides insights into your development environment.

### Commands

| Command                         | Description                     |
|---------------------------------|---------------------------------|
| `:NDE dynamicloader stats`      | Show performance statistics     |
| `:NDE dynamicloader languages`  | Display language support status |
| `:NDE dynamicloader formatters` | Show formatter configuration    |
| `:NDE dynamicloader clearcache` | Clear all dynamic loader caches |

### Features

- ⚡ **Performance Monitoring**: Track loading times and optimization
- 🎯 **Language Detection**: Automatic language-specific tool loading
- ✨ **Smart Formatting**: Context-aware formatter selection
- 🧹 **Cache Management**: Efficient caching with manual clear option

## 📝 Snippets System

Quickly access and use code snippets with intelligent language detection.

### Commands

| Command               | Description                     |
|-----------------------|---------------------------------|
| `:NDE snippetslist`   | List available snippets for current filetype |

### Features

- 🎯 **Language Detection**: Automatically shows snippets for current filetype
- 📚 **Rich Library**: Comprehensive snippets for 8+ programming languages
- 🔍 **Smart Search**: Easy discovery of available snippets
- ⚡  **Quick Access**: Instant snippet listing with usage instructions

### Supported Languages

- 🐍 **Python**: Classes, functions, dataclasses, async functions
- ⚡  **JavaScript/TypeScript**: React components, hooks, interfaces, arrow functions
- 🦀 **Rust**: Structs, error handling, async functions
- 🐹 **Go**: Structs, HTTP handlers, error handling
- 🔧 **C/C++**: Classes, header guards
- 🌙 **Lua**: Modules, Neovim plugins, autocmds
- 🌐  **HTML**: HTML5 boilerplate, component templates
- 🗄️ **SQL**: SELECT queries, table creation

## 🎉 General Commands

| Command              | Description                     |
|----------------------|---------------------------------|
| `:NDE help`          | Show complete command reference |
| `:NDE snippetslist`  | List available snippets for current file |
| `:NDE welcome`       | Display welcome message         |
| `:NDE status`        | Show comprehensive NDE status   |

## ✨ Features

### 🎭 Tab Completion
All NDE commands support intelligent tab completion:

```vim
:NDE <Tab>           " Shows: help, tips, tip, dynamicloader, snippetslist, welcome, status
:NDE tips <Tab>      " Shows: on, off
:NDE tip <Tab>       " Shows: show, next, random
:NDE dynamicloader <Tab>  " Shows: stats, languages, formatters, clearcache
```

### 🔄 Smart State Management
- Settings persist between Neovim sessions
- Intelligent context detection (only show tips when appropriate)
- Graceful error handling and user feedback

### 🎨 Beautiful UI
- Emoji-rich notifications and messages
- Consistent styling across all components
- Non-intrusive design that doesn't interrupt workflow

## 🛠️ Technical Details

### Architecture

```
nde/
├── command-suite.lua    # Central command dispatcher
├── tips.lua             # Tips system and management
└── README.md            # This documentation
```

### Integration Points

- **Launch System**: Automatically initialized in `launch.lua`
- **Performance Module**: Integrates with dynamic loader
- **Notification System**: Uses nvim-notify for beautiful alerts
- **File System**: Persistent settings in `nvim/data/nde_tips_settings.json`

### Configuration

NDE initializes with sensible defaults in `launch.lua`:

```lua
require("nde.tips").setup({
  enabled = true,    -- Show tips by default
  interval = 45000,  -- 45 seconds between tips
})
```

## 🎯 Usage Examples

### Enable Tips for Learning
```vim
:NDE tips on
" Tips will now appear every 45 seconds while coding
```

### Quick Tip When Stuck
```vim
:NDE tip random
" Get a random helpful tip instantly
```

### Check Available Snippets
```vim
:NDE snippetslist
" See all snippets for your current file type
```

### Check System Performance
```vim
:NDE dynamicloader stats
" See how fast your setup is loading
```

### Get Your Bearings
```vim
:NDE status
" See complete NDE status dashboard
```

## 🎊 What's New in v2.2.0

- 📝 **Snippets Integration**: New `:NDE snippetslist` command for quick snippet discovery
- 🔧 **LuaSnip Fix**: Resolved filetype handling issues in snippet configuration
- 🎯 **Enhanced Documentation**: Updated README and keybinding documentation
- 🚀 **Expanded Language Support**: Added support for more programming languages
- ✨ **Arial.nvim Integration**: Enhanced UI components and styling
- 💡 **Enhanced Tips System**: Smarter context detection and persistence
- ⚡  **Dynamic Loader Integration**: Performance monitoring and control
- 🎯 **Tab Completion**: Full autocomplete support for all commands

## 🤝 Contributing

NDE is designed to be extensible! Feel free to:

- Add new tip categories
- Enhance the dynamic loader
- Improve command functionality
- Submit bug reports and feature requests

## 📝 License

NDE is open source and available under your preferred license.

---

**Happy Coding with NDE! 🚀✨**

*Made with ❤️ for the Neovim community*

