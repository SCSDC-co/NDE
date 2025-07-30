# Opus TODO Manager

Opus is a powerful and intuitive TODO task manager built for the NDE (Neovim Development Environment). It provides a beautiful and efficient way to manage your tasks without ever leaving your editor.

## Features

- **NUI-Powered Interface**: Clean and interactive UI built with modern NUI components
- **Complete Task Management**: Add, remove, rename, and complete tasks with ease
- **Advanced Tagging System**: Organize your tasks with custom tags for better organization
- **Smart Filtering & Sorting**: Quickly find the tasks you need with powerful filters
- **JSON Storage**: Tasks are stored in a simple, human-readable JSON format at `~/.local/share/nvim/nde/opus.json`
- **Full Keyboard Navigation**: Designed for keyboard-driven workflows with intuitive shortcuts
- **Statistics & Insights**: Track your productivity with built-in task statistics
- **NDE Integration**: Seamlessly integrated with the NDE command suite

## Quick Start

### Opening Opus

The main interface can be opened with:

```vim
:NDE opus list
```

This opens the interactive task manager where you can perform all operations.

### Command Line Usage

For quick actions, use the NDE command suite:

```vim
:NDE opus add "Fix the parser bug"       " Add a new task
:NDE opus complete 1                     " Complete task #1
:NDE opus remove 2                       " Remove task #2
:NDE opus rename 1 "Updated task name"   " Rename task #1
```

### Getting Help

For comprehensive documentation:

```vim
:NDE opus help
```

This opens the complete documentation with all features, keybindings, and usage examples.

## Integration with NDE

Opus is seamlessly integrated into the NDE ecosystem:

- **Command Suite**: Accessible via `:NDE opus` commands
- **Theme Consistency**: Matches your current NDE theme
- **Performance**: Zero startup impact with lazy loading
- **Storage**: Uses NDE data directory structure

## Architecture

Opus follows NDE's modular architecture:

```
lua/opus/
├── init.lua           # Main module entry point
├── config.lua         # Configuration management
├── core/
│   └── init.lua       # Core task management logic
├── ui/
│   └── init.lua       # User interface components
├── utils/
│   ├── filters.lua    # Task filtering and sorting
│   └── json.lua       # JSON utilities
└── doc/
    └── opus.txt       # Complete documentation
```

## Storage Format

Tasks are stored in JSON format at `~/.local/share/nvim/nde/opus.json`:

```json
[
  {
    "name": "Fix the parser bug",
    "completed": false,
    "tags": [
        "bug", 
        "parser"
    ]
  }
]
```

This makes it easy to backup, sync, or integrate with other tools.

## Contributing

Opus is part of the NDE project. Contributions are welcome! See the main NDE repository for contribution guidelines.
