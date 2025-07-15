local M = {}

-- Setup nvim-dap and nvim-dap-ui
function M.setup(config)
  local ok_dap, dap = pcall(require, "dap")
  local ok_dapui, dapui = pcall(require, "dapui")
  
  if not ok_dap or not ok_dapui then
    vim.notify("DAP or DAP-UI not available, skipping debugger setup", vim.log.levels.WARN)
    return
  end
  
  -- Configure breakpoint signs
  vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
  vim.fn.sign_define('DapBreakpointCondition', { text = '◐', texthl = 'DapBreakpointCondition', linehl = '', numhl = '' })
  vim.fn.sign_define('DapBreakpointRejected', { text = '○', texthl = 'DapBreakpointRejected', linehl = '', numhl = '' })
  vim.fn.sign_define('DapLogPoint', { text = '◆', texthl = 'DapLogPoint', linehl = '', numhl = '' })
  vim.fn.sign_define('DapStopped', { text = '→', texthl = 'DapStopped', linehl = 'DapStoppedLine', numhl = '' })
  
  -- Set up highlight groups for breakpoints
  vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = '#e06c75' }) -- Red color
  vim.api.nvim_set_hl(0, 'DapBreakpointCondition', { fg = '#d19a66' }) -- Orange color
  vim.api.nvim_set_hl(0, 'DapBreakpointRejected', { fg = '#5c6370' }) -- Gray color
  vim.api.nvim_set_hl(0, 'DapLogPoint', { fg = '#61afef' }) -- Blue color
  vim.api.nvim_set_hl(0, 'DapStopped', { fg = '#98c379' }) -- Green color
  vim.api.nvim_set_hl(0, 'DapStoppedLine', { bg = '#2c323c' }) -- Dark background
  
  -- Setup DAP UI
  dapui.setup({
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
        size = 0.25,
        position = "bottom",
      },
    },
    floating = {
      max_height = 0.9,
      max_width = 0.9,
      border = "rounded",
      mappings = {
        close = { "q", "<Esc>" },
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
  
  -- Set up keymaps
  vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
  vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
  vim.keymap.set("n", "<leader>dsi", dap.step_into, { desc = "Step Into" })
  vim.keymap.set("n", "<leader>dso", dap.step_over, { desc = "Step Over" })
  vim.keymap.set("n", "<leader>dsu", dap.step_out, { desc = "Step Out" })
  vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Open REPL" })
  vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "Terminate" })
  vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
  
  -- Store debugger utilities globally
  _G.OptiSpec = _G.OptiSpec or {}
  _G.OptiSpec.debugger = {
    setup_adapter = M.setup_adapter,
    setup_configuration = M.setup_configuration,
  }
end

-- Setup debugger adapter for a language
function M.setup_adapter(language, adapter_config)
  local dap = require("dap")
  dap.adapters[language] = adapter_config
end

-- Setup debugger configuration for a language
function M.setup_configuration(language, configurations)
  local dap = require("dap")
  dap.configurations[language] = configurations
end

-- Plugin definitions
M.plugins = {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-dap", "nvim-neotest/nvim-nio" },
    keys = {
      { "<leader>db", desc = "Toggle Breakpoint" },
      { "<leader>dc", desc = "Continue" },
      { "<leader>du", desc = "Toggle DAP UI" },
    },
    config = function()
      M.setup({})
    end
  },
  {
    "nvim-neotest/nvim-nio",
    lazy = true,
  }
}

return M
