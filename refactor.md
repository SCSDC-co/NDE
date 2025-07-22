# NDE Starter - Nvim Config Refactor Roadmap

## Project Overview
Refactor bloated nvim config (95 plugins) into a streamlined system with:
- Core plugins (always enabled)
- Optional plugins (user-configurable)

## Core Plugins (Always Enabled)
- **UI/Visual**: hlchunk, neotree, telescope, bufferline, lualine, themery + themes, dashboard
- **Display**: satellite, virt-column, render-markdown
- **Completion**: cmp + all sources
- **UX Enhancement**: noice, snacks, mini, which-key, smart-splits
- **Terminal/Tools**: betterterm, coderunner
- **Editing**: vim-repeat, yanky, zen-mode, undo-tree
- **Git**: vim-fugitive
- **NDE Suite**: All NDE-related plugins (loaded via lua/launch.lua)
  - optispec, snapicon, and other NDE-only plugins

**Total Core Plugins: ~25**

## Implementation Plan

### Phase 1: Preparation
- [x] Create feature branch `refactor/nde-starter`
- [ ] Audit current plugin list and configs
- [ ] Document current plugin structure
- [ ] Identify all NDE suite plugins (loaded via lua/launch.lua)

### Phase 2: Plugin Management System
- [ ] Create plugin toggle system
  - [ ] `lua/config/plugin-manager.lua` - Core plugin loading logic
  - [ ] `lua/config/optional-plugins.lua` - Optional plugin definitions
  - [ ] User config file for enabling/disabling plugins
- [ ] Implement conditional loading mechanism

### Phase 3: Core Plugin Setup
- [ ] Move core plugins to always-load category
- [ ] Include all NDE suite plugins in core
- [ ] Add vim-fugitive to core plugins
- [ ] Ensure all core plugin configs work independently
- [ ] Test core-only configuration

### Phase 4: Optional Plugin System
- [ ] Categorize remaining ~70 plugins
- [ ] Create plugin groups (LSP, Git Extensions, Development, etc.)
- [ ] Implement lazy loading for optional plugins
- [ ] Create user-friendly toggle interface

### Phase 5: Configuration Preservation
- [ ] Ensure all existing plugin configs remain unchanged
- [ ] Test that optional plugins work when enabled
- [ ] Verify no breaking changes to current functionality

### Phase 6: User Experience
- [ ] Create setup wizard/interface for plugin selection
- [ ] Add documentation for plugin management
- [ ] Performance testing and optimization

### Phase 7: Testing & Validation
- [ ] Test with only core plugins
- [ ] Test with various optional plugin combinations
- [ ] Performance benchmarking (startup time)
- [ ] User acceptance testing

## Success Criteria
- [ ] Startup time improved with core-only config
- [ ] All existing functionality preserved
- [ ] Easy plugin enable/disable mechanism
- [ ] No breaking changes for current users
- [ ] Comprehensive documentation

## Branch Strategy
- Work branch: `refactor/nde-starter`
- Regular commits with descriptive messages
- PR back to main when complete

## Notes
- Preserve all existing config files
- Maintain backward compatibility
- Focus on user experience and performance
- All NDE suite plugins remain in core for consistency
- vim-fugitive essential for git workflow
