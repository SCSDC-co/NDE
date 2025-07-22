# NDE Plugin Audit - Updated with New Core Plugins

## Overview
- **Total Plugin Files**: 67 (excluding init.lua)
- **Plugin Loading**: Via lazy.nvim with `{ import = 'plugins' }`
- **NDE-only Plugins**: Loaded separately via `lua/launch.lua`
- **Plugin Organization**: Category-based directory structure

## Updated Core Plugins List (30 total)

### Always Enabled Core Plugins:
1. **dashboard** ✅ (core/dashboard.lua)
2. **snacks** ✅ (core/snacks.lua) 
3. **which-key** ✅ (core/which-key.lua)
4. **hardtime** ✅ (core/hardtime.lua) **[NEWLY ADDED]**
5. **bufferline** ✅ (ui/bufferline.lua)
6. **hlchunk** ✅ (ui/hlchunk.lua)
7. **lualine** ✅ (ui/lualine.lua)
8. **noice** ✅ (ui/noice.lua)
9. **satellite** ✅ (ui/satellite.lua)
10. **themery** ✅ (ui/themery.lua) + all themes
11. **virt-column** ✅ (ui/virt-column.lua)
12. **zen-mode** ✅ (ui/zen.lua)
13. **dropbar** ✅ (ui/dropbar.lua) **[NEWLY ADDED]**
14. **neotree** ✅ (navigation/neotree.lua)
15. **smart-splits** ✅ (navigation/smart-splits.lua)
16. **telescope** ✅ (navigation/telescope.lua)
17. **cmp** ✅ (editing/cmp.lua) + all sources
18. **mini.surround** ✅ (editing/mini.lua)
19. **mini.align** ✅ (editing/mini-align.lua)
20. **mini.comment** ✅ (editing/mini.lua)
21. **mini.pairs** ✅ (editing/mini.lua)
22. **vim-repeat** ✅ (editing/repeat.lua)
23. **undotree** ✅ (editing/undotree.lua)
24. **yanky** ✅ (editing/yanky.lua)
25. **coderunner** ✅ (development/code-runner.lua)
26. **render-markdown** ✅ (development/render-markdown.lua)
27. **vim-fugitive** ✅ (git/vim-fugitive.lua)
28. **gitsigns** ✅ (git/gitsigns.lua) **[NEWLY ADDED]**
29. **betterterm** ✅ (terminal/betterterm.lua)
30. **optispec** ✅ (NDE-only, loaded via launch.lua)
31. **snapicon** ✅ (NDE-only, loaded via launch.lua)
32. **nde.tips** ✅ (NDE-only, loaded via launch.lua)

## Optional Plugins (~38 remaining)

### Core Category - Optional
- `hardtime.lua`
- `legendary.lua`
- `persistence.lua`
- `vim-be-good.lua`

### UI Category - Optional  
- `animate.lua`
- `highlight-colors.lua`
- `incline.lua`
- `presence.lua`
- `rainbow-delimiters.lua`
- `symbol-usage.lua`
- `url-open.lua`

### Navigation Category - Optional
- `aerial.lua`
- `harpoon.lua`
- `leap.lua`
- `numb.lua`
- `oil.lua`

### Editing Category - Optional
- `autotag.lua`
- `blink.lua`
- `comment.lua`
- `dial.lua`
- `hlargs.lua`
- `illuminate.lua`
- `snippet.lua`
- `spectre.lua`
- `tabout.lua`
- `treesj.lua`
- `visual-multi.lua`
- `minty.lua`

### Development Category - Optional
- `avante.lua`
- `codeium.lua`
- `playground.lua`
- `supermaven.lua`
- `todo-comments.lua`
- `trouble.lua`

### Git Category - Optional
- `diffview.lua`
- `vim-flog.lua`

### Terminal Category - Optional
- `toggleterm.lua`

### Coding Category - Optional
- `refactoring.lua`

## Plugin Structure Issues Found
1. **Missing categories in init.lua**: `coding` directory exists but not mentioned
2. **Non-existent categories**: `lsp` and `debugging` mentioned but don't exist
3. **Mini suite**: Need to identify all mini.* plugins loaded via mini.lua

## Implementation Strategy
1. **Phase 2**: Create plugin management system with core/optional separation
2. **Phase 3**: Implement conditional loading based on user preferences
3. **Preserve all configs**: No changes to existing plugin configurations
4. **User control**: Simple toggle system for optional plugins

## Next Steps
- ✅ Update categories in lua/plugins/init.lua
- Create plugin management system
- Implement user configuration interface
