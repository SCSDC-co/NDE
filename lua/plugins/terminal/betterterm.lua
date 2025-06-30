-- BetterTerm.nvim - VSCode-style terminal experience for NDE
-- Provides a bottom terminal panel that covers 30% height and 100% width

return {
  "CRAG666/betterTerm.nvim",
  lazy = true,
  keys = {
    { "<F7>", desc = "🔧 VSCode-style Terminal" },
  },
  config = function()
    local betterTerm = require("betterTerm")
    
    -- Configure BetterTerm with VSCode-style bottom terminal
    betterTerm.setup({
      prefix = "BetterTerm_",
      startInsert = true,
      position = "bot", -- Bottom position like VSCode
      size = 15, -- Terminal height in lines (approximately 30% of typical screen)
      border = "single", -- Clean single border for bottom panel
      winhl = "Normal:TerminalNormal,FloatBorder:TerminalBorder",
      
      -- Terminal behavior
      open_in_current_file_dir = true,
      
      -- Performance optimizations
      remember_mode = true,
      auto_close = false,
    })
    
    -- F7 keybinding for VSCode-style terminal
    vim.keymap.set("n", "<F7>", function()
      betterTerm.open()
    end, { desc = "🔧 VSCode-style Terminal" })
    
    -- Toggle terminal with same key (F7 acts as toggle)
    vim.keymap.set("t", "<F7>", function()
      betterTerm.open() -- open() toggles the terminal
    end, { desc = "Toggle Terminal" })
    
    -- Terminal management shortcuts
    vim.keymap.set("t", "<C-t>", function()
      -- Create new terminal with next index
      local next_index = 1
      while vim.fn.bufexists("BetterTerm_" .. next_index) == 1 do
        next_index = next_index + 1
      end
      betterTerm.open(next_index)
    end, { desc = "New Terminal Tab" })
    
    vim.keymap.set("t", "<C-w>", function()
      -- Close current buffer (terminal)
      vim.cmd("bd!")
    end, { desc = "Close Terminal Tab" })
    
    -- Terminal selector
    vim.keymap.set("t", "<C-Tab>", function()
      betterTerm.select() -- Opens terminal selector
    end, { desc = "Select Terminal" })
    
    -- Alternative: quick switch to specific terminal numbers
    for i = 1, 5 do
      vim.keymap.set("t", "<C-" .. i .. ">", function()
        betterTerm.open(i) -- Switch to terminal by number
      end, { desc = "Terminal " .. i })
    end
    
    -- Escape to normal mode (but keep terminal open)
    vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit Terminal Insert Mode" })
    
    -- Terminal navigation improvements (keep window navigation working)
    vim.keymap.set("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Move to left window" })
    vim.keymap.set("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Move to below window" })
    vim.keymap.set("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Move to above window" })
    vim.keymap.set("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Move to right window" })
    
    -- Auto-commands for better terminal experience
    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "*",
      callback = function()
        -- Disable line numbers in terminal
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
        
        -- Start in insert mode
        vim.cmd("startinsert")
      end,
      desc = "Terminal setup"
    })

  end,
}
