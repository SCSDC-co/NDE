# Performance-Optimized Neovim Language and Formatter Loader

🚀 **Smart lazy loading system for Neovim language configurations and formatters**

This module provides performance-optimized loading of language configurations and formatters with full backward compatibility. It uses intelligent priority-based loading to improve Neovim startup and responsiveness.

## ✨ Features

- **🎯 Smart Lazy Loading**: Languages load based on file extensions with performance-aware delays
- **⚡  Aggressive Caching**: File types, language configs, and formatter configs are cached
- **🏃 Priority-Based Loading**: Fast languages load immediately, slower ones load with delays
- **🔧 Fully Configurable**: Users can customize delays, disable optimizations, or add custom mappings
- **🔄 100% Backward Compatible**: Drop-in replacement for existing setups
- **📊 Performance Monitoring**: Built-in commands to monitor performance and cache status
- **🌐  Universal**: Works across different systems with adaptive performance profiles

## 📁 Installation

1. **Copy the performance module to your Neovim config**:
   ```bash
   # Assuming your config is in ~/.config/nvim/
   mkdir -p ~/.config/nvim/lua/performance/langs/
   # Copy the files from this repository
   ```

2. **Your directory structure should look like**:
   ```
   ~/.config/nvim/lua/
   ├── langs/              # Your existing language configs
   │   ├── init.lua
   │   ├── python.lua
   │   ├── rust.lua
   │   └── ...
   ├── formatters/         # Your existing formatter configs
   │   ├── init.lua
   │   ├── black.lua
   │   └── ...
   └── performance/        # New performance module
       ├── dynamic_loader.lua
       ├── formatters.lua
       ├── langs/
       │   └── init.lua
       └── README.md
   ```

## 🚀 Quick Start

### Basic Usage (Drop-in Replacement)

```lua
-- Replace your existing language/formatter loading with:
local langs = require('performance.langs')
local formatters = require('performance.formatters')

-- Everything works exactly the same!
local config = langs.setup()
local formatter_config = formatters.setup()

-- All your existing functions work unchanged
local lsp_configs = langs.get_lsp_configs()
local dap_configs = langs.get_dap_configs()
local mason_tools = langs.get_mason_tools()
```

### Custom Configuration

```lua
local dynamic_loader = require('performance.dynamic_loader')

-- Configure performance settings
dynamic_loader.configure({
  -- Enable/disable performance optimizations
  enabled = true,
  
  -- Adjust delay multiplier based on your system
  delay_multiplier = 0.5,  -- Faster system = lower multiplier
  
  -- Set maximum delay cap
  max_delay_ms = 100,
  
  -- Add custom file extensions
  custom_extensions = {
    ["svelte"] = { lang = "javascript_typescript", priority = 4, delay_ms = 80 },
    ["vue"] = { lang = "javascript_typescript", priority = 4, delay_ms = 80 },
  }
})

-- Then setup as normal
local langs = require('performance.langs')
local config = langs.setup()
```

## ⚙️ Configuration Options

### Performance Settings

```lua
dynamic_loader.configure({
  enabled = true,              -- Enable/disable optimizations
  delay_multiplier = 1.0,      -- Multiply all delays (0.5 = faster, 2.0 = slower)
  max_delay_ms = 150,          -- Maximum delay cap
  min_delay_ms = 20,           -- Minimum delay for non-priority languages
  auto_adapt = true,           -- Future: auto-detect system performance
})
```

### System-Specific Tuning

```lua
-- For fast SSDs/powerful machines
dynamic_loader.configure({ delay_multiplier = 0.3 })

-- For slower systems
dynamic_loader.configure({ delay_multiplier = 2.0 })

-- Disable optimizations completely
dynamic_loader.configure({ enabled = false })
```

### Custom Language Extensions

```lua
dynamic_loader.configure({
  custom_extensions = {
    -- Add new file extensions
    ["kt"] = { lang = "kotlin", priority = 2, delay_ms = 40 },
    ["scala"] = { lang = "scala", priority = 3, delay_ms = 60 },
    
    -- Override existing extensions
    ["ts"] = { lang = "javascript_typescript", priority = 2, delay_ms = 30 }, -- Make TS faster
  }
})
```

## 📊 Performance Monitoring

### Built-in Commands

```vim
:DynamicLoaderStats          " Show performance statistics
:DynamicLoaderClearCache     " Clear all caches
:FormattersPerformanceStats  " Show formatter-specific stats
```

### Programmatic Monitoring

```lua
-- Get performance statistics
local stats = require('performance.dynamic_loader').get_performance_stats()
print("Loaded languages: " .. stats.loaded_languages)
print("Cache hits: ", vim.inspect(stats.cache_hits))

-- Get current configuration
local config = require('performance.dynamic_loader').get_config()
print("Delay multiplier: " .. config.delay_multiplier)
```

## 🎯 Priority System

Languages are loaded based on priority levels:

### Priority 1 (Immediate Loading)
- **Lua** - Neovim's native language
- **Go** - Generally fast to load
- **Python** - Common and well-optimized
- **C/C headers** - Simple configurations

### Priority 2 (30ms delay)
- **Rust** - Moderate complexity
- **Java** - Well-established tooling
- **Zig** - Lightweight language

### Priority 3 (60ms delay)
- **Shell scripts** - Various dialects
- **PHP** - Web development

### Priority 4 (100ms delay)
- **TypeScript/JavaScript** - Complex tooling ecosystem
- **C++** - Heavy language servers

## 🔄 Migration Guide

### From Existing Setup

**Before:**
```lua
local langs = require('langs')
local formatters = require('formatters')
local config = langs.setup()
```

**After:**
```lua
local langs = require('performance.langs')
local formatters = require('performance.formatters')
local config = langs.setup()  -- Same API!
```

### Gradual Migration

1. **Test with one module first**:
   ```lua
   local langs = require('performance.langs')  -- New
   local formatters = require('formatters')    -- Old
   ```

2. **Monitor performance**:
   ```vim
   :DynamicLoaderStats
   ```

3. **Migrate formatters when ready**:
   ```lua
   local formatters = require('performance.formatters')  -- New
   ```

## 🐛 Troubleshooting

### Performance Issues

```lua
-- Check what's loaded
:DynamicLoaderStats

-- Clear caches if needed
:DynamicLoaderClearCache

-- Adjust delays for your system
require('performance.dynamic_loader').configure({ delay_multiplier = 0.5 })
```

### Compatibility Issues

```lua
-- Disable optimizations temporarily
require('performance.dynamic_loader').configure({ enabled = false })

-- Or use original modules
local langs = require('langs')  -- Original
```

### Debug Information

```lua
-- Get current configuration
local config = require('performance.dynamic_loader').get_config()
print(vim.inspect(config))

-- Check loaded languages
local stats = require('performance.dynamic_loader').get_performance_stats()
print("Loaded: " .. stats.loaded_languages .. " languages")
```

## 🤝 Contributing

### Adding New Languages

1. **Add to the extension map**:
   ```lua
   -- In dynamic_loader.lua
   ["new_ext"] = { lang = "new_language", priority = 2, delay_ms = 30 },
   ```

2. **Add to available languages**:
   ```lua
   -- In AVAILABLE_LANGUAGES
   "new_language",
   ```

3. **Test the integration**:
   ```vim
   :DynamicLoaderStats
   ```

### Performance Optimization

1. **Benchmark your changes** using the provided tools
2. **Test on different systems** (fast SSDs vs HDDs)
3. **Monitor memory usage** with `:DynamicLoaderStats`

## 📈 Performance Benefits

- **Faster startup**: Only priority 1 languages load during startup
- **Responsive editing**: File opening doesn't wait for all languages
- **Memory efficient**: Unused languages stay unloaded
- **Scalable**: Easy to add new languages without impacting existing ones
- **Adaptive**: Users can tune for their specific system performance

## 📝 License

This module is designed to be part of Neovim configurations and follows the same licensing as your Neovim setup.

---

**Note**: This is a performance optimization layer that maintains 100% compatibility with existing language and formatter configurations. You can enable/disable it without any breaking changes to your setup.

