-- 🎣 harpoon.nvim: Quick file navigation and bookmarking
-- Perfect for jumping between your most important files instantly
-- Think of it as bookmarks but way cooler and faster!

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>m", desc = "🎣 Harpoon" },
    { "<leader>mt", desc = "🎣 Harpoon Quick Menu" },
    { "<M-1>", desc = "🎣 Harpoon File 1" },
    { "<M-2>", desc = "🎣 Harpoon File 2" },
    { "<M-3>", desc = "🎣 Harpoon File 3" },
    { "<M-4>", desc = "🎣 Harpoon File 4" },
  },
  config = function()
    local harpoon = require("harpoon")
    
    -- REQUIRED: Setup harpoon
    harpoon:setup({
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
        key = function()
          return vim.loop.cwd()
        end,
      },
    })
    
    -- Core harpoon keybindings
    vim.keymap.set("n", "<leader>ma", function() harpoon:list():add() end, 
      { desc = "🎯 Add File to Harpoon" })
    
    vim.keymap.set("n", "<leader>mt", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
      { desc = "🎣 Toggle Harpoon Quick Menu" })
    
    -- Quick access to first 4 harpooned files using Alt+number
    vim.keymap.set("n", "<M-1>", function() harpoon:list():select(1) end,
      { desc = "🎣 Harpoon File 1" })
    vim.keymap.set("n", "<M-2>", function() harpoon:list():select(2) end,
      { desc = "🎣 Harpoon File 2" })
    vim.keymap.set("n", "<M-3>", function() harpoon:list():select(3) end,
      { desc = "🎣 Harpoon File 3" })
    vim.keymap.set("n", "<M-4>", function() harpoon:list():select(4) end,
      { desc = "🎣 Harpoon File 4" })
    
    -- Navigation through harpoon list
    vim.keymap.set("n", "<leader>mp", function() harpoon:list():prev() end,
      { desc = "🔙 Previous Harpoon File" })
    vim.keymap.set("n", "<leader>mn", function() harpoon:list():next() end,
      { desc = "🔜 Next Harpoon File" })
    
    -- Clear all harpoon marks
    vim.keymap.set("n", "<leader>mc", function() harpoon:list():clear() end,
      { desc = "🗑️ Clear All Harpoon Marks" })
    
    -- Replace a specific harpoon mark
    vim.keymap.set("n", "<leader>m1", function() harpoon:list():replace_at(1) end,
      { desc = "🔄 Replace Harpoon Mark 1" })
    vim.keymap.set("n", "<leader>m2", function() harpoon:list():replace_at(2) end,
      { desc = "🔄 Replace Harpoon Mark 2" })
    vim.keymap.set("n", "<leader>m3", function() harpoon:list():replace_at(3) end,
      { desc = "🔄 Replace Harpoon Mark 3" })
    vim.keymap.set("n", "<leader>m4", function() harpoon:list():replace_at(4) end,
      { desc = "🔄 Replace Harpoon Mark 4" })
  end,
}
