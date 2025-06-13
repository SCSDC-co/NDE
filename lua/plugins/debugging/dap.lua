return {
  {
    "mfussenegger/nvim-dap",
    lazy = true, -- ⚡ PERFORMANCE: Only load when debugging
    keys = {
      -- Use the actual keys from keymaps.lua
      { "<F1>", function() require('dap').toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
      { "<F2>", function() require('dap').continue() end, desc = "Debug: Continue" },
      { "<F3>", function() require('dap').step_into() end, desc = "Debug: Step Into" },
      { "<F4>", function() require('dap').step_over() end, desc = "Debug: Step Over" },
      { "<leader>du", function() require('dapui').toggle() end, desc = "Debug: Toggle UI" },
    },
    cmd = {
      "DapToggleBreakpoint",
      "DapContinue", 
      "DapStepOver",
      "DapStepInto",
      "DapStepOut",
      "DapTerminate",
      "DapSetLogLevel",
      "DapShowLog",
    },
    dependencies = {
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",
      "theHamsta/nvim-dap-virtual-text",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Get DAP configurations from language modules
      local lang_config = require("langs").setup()
      local dap_configs = lang_config.dap_configs
      local mason_tools = lang_config.mason_tools

      -- Mason DAP setup for automatic installation
      require("mason-nvim-dap").setup({
        ensure_installed = mason_tools.debuggers,
        automatic_installation = true,
        handlers = {},
      })

      -- Enable virtual text
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = false,
        clear_on_continue = false,
        display_callback = function(variable, buf, stackframe, node, options)
          if options.virt_text_pos == "inline" then
            return " = " .. variable.value
          else
            return variable.name .. " = " .. variable.value
          end
        end,
      })

      -- Setup adapters and configurations from language modules
      for lang_name, config in pairs(dap_configs) do
        if config.adapter then
          -- Set up adapter
          if config.adapter.name then
            dap.adapters[config.adapter.name] = config.adapter
          else
            -- For language-specific adapters
            dap.adapters[lang_name] = config.adapter
          end
        end
        
        if config.configurations then
          -- Map language names to filetypes
          local lang_to_filetype = {
            python = "python",
            rust = "rust",
            c_cpp = { "c", "cpp" },
            javascript_typescript = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
            lua = "lua",
            go = "go",
          }
          
          local filetypes = lang_to_filetype[lang_name]
          if type(filetypes) == "string" then
            filetypes = { filetypes }
          end
          
          if filetypes then
            for _, ft in ipairs(filetypes) do
              dap.configurations[ft] = config.configurations
            end
          end
        end
      end

      -- Key mappings are handled in keymaps.lua to avoid conflicts
      -- F1-F4 and <leader>du are mapped there
    end,
  },
  {
    "nvim-telescope/telescope-dap.nvim",
    lazy = true, -- ⚡ PERFORMANCE: Only load when debugging
    keys = {
      { "<leader>db", function() require('telescope').extensions.dap.list_breakpoints() end, desc = "DAP: List Breakpoints" },
      { "<leader>dc", function() require('telescope').extensions.dap.configurations() end, desc = "DAP: Configurations" },
      { "<leader>dv", function() require('telescope').extensions.dap.variables() end, desc = "DAP: Variables" },
      { "<leader>df", function() require('telescope').extensions.dap.frames() end, desc = "DAP: Frames" },
    },
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("telescope").load_extension("dap")
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    lazy = true, -- ⚡ PERFORMANCE: Only load when debugging
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      
      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▻" },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = 10,
            position = "bottom",
          },
        },
      })

      -- Auto open/close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
      
      vim.keymap.set("n", "<Leader>dt", function()
        dapui.toggle()
      end, { desc = "DAP Toggle UI" })
    end,
  },
}
