-- NDE VSCode Integration Module
-- Provides seamless integration when using NDE with VSCode Neovim extension

local M = {}

-- Check if we're running inside VSCode
function M.is_vscode()
  return vim.g.vscode ~= nil
end

-- Get the enabled plugins for VSCode mode (based on your actual plugin list)
function M.get_enabled_plugins()
  return {
    -- Core NDE systems that work well in VSCode
    "lazy.nvim",
    "plenary.nvim",
    "nui.nvim", -- For which-key and other UI components
    "nvim-web-devicons", -- Icons still useful
    
    -- Essential editing plugins that enhance VSCode
    "mini.surround", -- Text objects work great
    "mini.comment", -- Better than VSCode commenting
    "mini.pairs", -- Auto-pairing
    "mini.align", -- Text alignment
    "dial.nvim", -- Increment/decrement
    "vim-repeat", -- Repeat plugin actions
    "vim-visual-multi", -- Multiple cursors (better than VSCode)
    "yanky.nvim", -- Enhanced clipboard
    "leap.nvim", -- Amazing motion plugin
    "tabout.nvim", -- Smart tab navigation
    "blink.nvim", -- EOL ; and , insertion
    
    -- NDE-specific modules that work in VSCode
    "hardtime.nvim", -- Vim motion discipline
    "which-key.nvim", -- Command discovery
    "undotree", -- Undo tree visualization
    
    -- Useful utilities
    "hover.nvim", -- Enhanced hover
    "vim-be-good", -- Vim training game
    "persistence.nvim", -- Session management
    "legendary.nvim", -- Command palette enhancement
    
    -- Development tools that enhance VSCode
    "telescope.nvim", -- File picker (if user prefers over VSCode)
    "harpoon", -- File bookmarking
    "oil.nvim", -- File management
    
    -- Git tools (some users prefer these over VSCode git)
    "vim-fugitive",
    "vim-flog", 
    "gitsigns.nvim", -- Inline git signs
    
    -- Treesitter (syntax highlighting can be useful)
    "nvim-treesitter",
    "nvim-ts-autotag",
    "vim-matchup",
    
    -- Smart editing
    "trouble.nvim", -- Enhanced diagnostics
    "todo-comments.nvim", -- TODO highlighting
    "vim-illuminate", -- Symbol highlighting
  }
end

-- Get plugins that should be DISABLED in VSCode (UI conflicts)
function M.get_disabled_plugins()
  return {
    -- Dashboard and UI that conflicts with VSCode
    "snacks.nvim", -- Dashboard and UI framework
    "bufferline.nvim", -- VSCode has tabs
    "lualine.nvim", -- VSCode has status bar
    "noice.nvim", -- Command line UI
    "nvim-notify", -- VSCode handles notifications
    "dropbar.nvim", -- VSCode has breadcrumbs
    "incline.nvim", -- Floating winbar
    "edgy.nvim", -- Window management
    "satellite.nvim", -- Scrollbar
    "rainbow-delimiters.nvim", -- VSCode has bracket matching
    "deadcolumn.nvim", -- VSCode has rulers
    "neodim", -- VSCode handles unused variables
    "presence.nvim", -- Discord presence
    "smart-splits.nvim", -- Window management
    "zen-mode.nvim", -- VSCode has zen mode
    
    -- LSP and completion (VSCode handles these)
    "nvim-lspconfig",
    "mason.nvim",
    "mason-lspconfig.nvim",
    "nvim-cmp",
    "cmp-buffer",
    "cmp-calc", 
    "cmp-cmdline",
    "cmp-emoji",
    "cmp-nvim-lsp",
    "cmp-nvim-lsp-signature-help",
    "cmp-nvim-lua",
    "cmp-path",
    "cmp-spell",
    "cmp_luasnip",
    "lspkind.nvim",
    "conform.nvim", -- VSCode handles formatting
    "symbol-usage.nvim", -- VSCode shows references
    
    -- AI completion (VSCode has better AI integration)
    "codeium.nvim",
    "supermaven-nvim",
    "avante.nvim",
    
    -- Snippets (VSCode handles these)
    "LuaSnip",
    "friendly-snippets",
    
    -- File explorers (VSCode has explorer)
    "neo-tree.nvim",
    
    -- Terminal (VSCode has integrated terminal)
    "toggleterm.nvim",
    "betterTerm.nvim",
    
    -- Debugging (VSCode handles this better)
    "nvim-dap",
    "nvim-dap-ui",
    "nvim-nio",
    
    -- Color and theme plugins
    "kanagawa.nvim", -- VSCode handles themes
    "nvim-highlight-colors", -- VSCode has color preview
    "minty", -- Color picker
    "volt", -- Color picker dependency
    
    -- Development tools VSCode handles better
    "nvim-spectre", -- Find and replace
    "diffview.nvim", -- VSCode has better diff
    "code_runner.nvim", -- VSCode has run buttons
    "code-playground.nvim", -- Not needed in VSCode
    "render-markdown.nvim", -- VSCode has markdown preview
    
    -- Image and media
    "img-clip.nvim", -- VSCode handles images
    
    -- UI components
    "shellRaining/hlchunk.nvim", -- Indent guides
    "dressing.nvim", -- UI improvements
  }
end

-- Configure Lazy.nvim for VSCode mode
function M.setup_lazy_config()
  if not M.is_vscode() then
    return
  end
  
  local Config = require("lazy.core.config")
  local enabled = M.get_enabled_plugins()
  
  -- Disable checker and change detection for better performance in VSCode
  Config.options.checker.enabled = false
  Config.options.change_detection.enabled = false
  
  -- Only load enabled plugins or those explicitly marked for VSCode
  Config.options.defaults.cond = function(plugin)
    return vim.tbl_contains(enabled, plugin.name) or plugin.vscode
  end
  
  vim.notify("🎯 NDE VSCode mode activated! " .. #enabled .. " plugins enabled for VSCode.", 
    vim.log.levels.INFO, 
    { title = "🚀 NDE VSCode Integration" }
  )
end

-- Setup VSCode-specific keymaps
function M.setup_keymaps()
  if not M.is_vscode() then
    return
  end
  
  -- VSCode action helper
  local function vscode_action(action)
    return function()
      require('vscode').action(action)
    end
  end
  
  -- VSCode notify helper
  local function vscode_notify(action)
    return "<Cmd>call VSCodeNotify('" .. action .. "')<CR>"
  end
  
  -- File and search operations
  vim.keymap.set("n", "<leader><space>", "<cmd>Find<cr>", { desc = "VSCode: Quick Open" })
  vim.keymap.set("n", "<leader>/", vscode_action('workbench.action.findInFiles'), { desc = "VSCode: Find in Files" })
  vim.keymap.set("n", "<leader>ff", vscode_action('workbench.action.quickOpen'), { desc = "VSCode: Quick Open" })
  vim.keymap.set("n", "<leader>fg", vscode_action('workbench.action.findInFiles'), { desc = "VSCode: Find in Files" })
  vim.keymap.set("n", "<leader>ss", vscode_action('workbench.action.gotoSymbol'), { desc = "VSCode: Go to Symbol" })
  
  -- Navigation (override NDE defaults)
  vim.keymap.set("n", "<S-h>", vscode_notify('workbench.action.previousEditor'), { desc = "VSCode: Previous Tab" })
  vim.keymap.set("n", "<S-l>", vscode_notify('workbench.action.nextEditor'), { desc = "VSCode: Next Tab" })
  vim.keymap.set("n", "<leader>bd", vscode_notify('workbench.action.closeActiveEditor'), { desc = "VSCode: Close Tab" })
  
  -- Keep undo/redo in sync with VSCode
  vim.keymap.set("n", "u", vscode_notify('undo'), { desc = "VSCode: Undo" })
  vim.keymap.set("n", "<C-r>", vscode_notify('redo'), { desc = "VSCode: Redo" })
  
  -- Terminal integration
  vim.keymap.set("n", "<F7>", vscode_action('workbench.action.terminal.toggleTerminal'), { desc = "VSCode: Toggle Terminal" })
  vim.keymap.set("n", "<F12>", vscode_action('workbench.action.terminal.new'), { desc = "VSCode: New Terminal" })
  vim.keymap.set("n", "<leader>tt", vscode_action('workbench.action.terminal.toggleTerminal'), { desc = "VSCode: Toggle Terminal" })
  
  -- Code actions and LSP-like features
  vim.keymap.set("n", "<leader>ca", vscode_action('editor.action.quickFix'), { desc = "VSCode: Code Actions" })
  vim.keymap.set("n", "<leader>cr", vscode_action('editor.action.rename'), { desc = "VSCode: Rename Symbol" })
  vim.keymap.set("n", "gd", vscode_action('editor.action.revealDefinition'), { desc = "VSCode: Go to Definition" })
  vim.keymap.set("n", "gr", vscode_action('editor.action.goToReferences'), { desc = "VSCode: Go to References" })
  vim.keymap.set("n", "gi", vscode_action('editor.action.goToImplementation'), { desc = "VSCode: Go to Implementation" })
  vim.keymap.set("n", "K", vscode_action('editor.action.showHover'), { desc = "VSCode: Show Hover" })
  
  -- File operations
  vim.keymap.set("n", "<leader>fs", vscode_notify('workbench.action.files.save'), { desc = "VSCode: Save File" })
  vim.keymap.set("n", "<leader>fa", vscode_notify('workbench.action.files.saveAll'), { desc = "VSCode: Save All" })
  vim.keymap.set("n", "<leader>fn", vscode_action('explorer.newFile'), { desc = "VSCode: New File" })
  
  -- Git integration
  vim.keymap.set("n", "<leader>gg", vscode_action('workbench.view.scm'), { desc = "VSCode: Source Control" })
  vim.keymap.set("n", "<leader>gp", vscode_action('git.push'), { desc = "VSCode: Git Push" })
  vim.keymap.set("n", "<leader>gc", vscode_action('git.commitStaged'), { desc = "VSCode: Git Commit" })
  
  -- Formatting
  vim.keymap.set("n", "<leader>cf", vscode_action('editor.action.formatDocument'), { desc = "VSCode: Format Document" })
  vim.keymap.set("v", "<leader>cf", vscode_action('editor.action.formatSelection'), { desc = "VSCode: Format Selection" })
  
  -- Explorer
  vim.keymap.set("n", "<leader>e", vscode_action('workbench.action.toggleSidebarVisibility'), { desc = "VSCode: Toggle Sidebar" })
  vim.keymap.set("n", "<leader>o", vscode_action('workbench.action.toggleSidebarVisibility'), { desc = "VSCode: Toggle Sidebar" })
  
  -- NDE-specific commands that still work
  vim.keymap.set("n", "<leader>nh", ":NDE minty help<CR>", { desc = "NDE: Minty Help" })
  vim.keymap.set("n", "<leader>nt", ":NDE tips<CR>", { desc = "NDE: Toggle Tips" })
  vim.keymap.set("n", "<leader>nm", ":NDE hardmode<CR>", { desc = "NDE: Hard Mode Status" })
  vim.keymap.set("n", "<leader>nH", ":NDE health<CR>", { desc = "NDE: Health Check" })
end

-- Override terminal function for VSCode
function M.terminal()
  if M.is_vscode() then
    require("vscode").action("workbench.action.terminal.toggleTerminal")
  else
    -- Fallback to regular terminal behavior
    vim.cmd("ToggleTerm")
  end
end

-- Main setup function
function M.setup()
  if not M.is_vscode() then
    return
  end
  
  -- Disable problematic options in VSCode
  vim.opt.laststatus = 0  -- Hide status line
  vim.opt.ruler = false   -- Hide ruler
  vim.opt.showcmd = false -- Hide command display
  vim.opt.cmdheight = 1   -- Minimal command height
  vim.opt.showtabline = 0 -- Hide tab line
  
  -- Setup Lazy config for VSCode
  M.setup_lazy_config()
  
  -- Setup VSCode-specific keymaps after plugins load
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      M.setup_keymaps()
    end,
  })
  
  -- Ensure essential NDE features still work
  vim.defer_fn(function()
    -- Initialize NDE command suite
    local ok, nde_cmd = pcall(require, "nde.command-suite")
    if ok then
      nde_cmd.setup()
    end
    
    -- Initialize tips system (but disable auto-tips)
    local tips_ok, tips = pcall(require, "nde.tips")
    if tips_ok then
      tips.setup({ enabled = false }) -- Disable auto-tips in VSCode
    end
    
    -- Add health check
    local health_ok, health = pcall(require, "utils.health")
    if health_ok then
      vim.api.nvim_create_user_command("NDEHealth", health.check, { desc = "NDE Health Check" })
    end
  end, 100)
end

-- Return VSCode-compatible plugin specs
function M.get_plugin_overrides()
  if not M.is_vscode() then
    return {}
  end
  
  return {
    -- Disable treesitter highlighting (VSCode handles this)
    {
      "nvim-treesitter/nvim-treesitter",
      opts = { 
        highlight = { enable = false }, -- VSCode handles syntax highlighting
        indent = { enable = false },    -- VSCode handles indentation
      },
    },
    
    -- Configure which-key for VSCode
    {
      "folke/which-key.nvim",
      opts = {
        preset = "modern",
        delay = 1000, -- Longer delay in VSCode
        plugins = {
          marks = false,     -- VSCode handles marks
          registers = false, -- VSCode handles registers
        },
      },
    },
    
    -- Keep yanky but with minimal config
    {
      "gbprod/yanky.nvim",
      opts = {
        highlight = {
          on_put = false,  -- VSCode might conflict
          on_yank = true,  -- Keep visual feedback
          timer = 200,     -- Shorter in VSCode
        },
        system_clipboard = {
          sync_with_ring = true, -- Keep VSCode clipboard sync
        },
      },
    },
    
    -- Hardtime still works great in VSCode
    {
      "m4xshen/hardtime.nvim",
      opts = {
        enabled = true,
        max_count = 6,
      },
    },
    
    -- Configure telescope for minimal VSCode usage
    {
      "nvim-telescope/telescope.nvim",
      opts = {
        defaults = {
          layout_config = {
            prompt_position = "top",
          },
          sorting_strategy = "ascending",
        },
      },
    },
  }
end

return M
