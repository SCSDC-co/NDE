-- Local minty override plugin
-- This replaces the original minty functions with custom rounded borders and proper theming

local M = {}

M.setup = function()
  -- Override the original minty huefy and shades open functions after minty is loaded
  vim.defer_fn(function()
    local huefy_override = require("local_plugins.minty.huefy.init")
    local shades_override = require("local_plugins.minty.shades.init")
    
    -- Get the original minty modules and replace their open functions
    local huefy = require("minty.huefy")
    local shades = require("minty.shades")
    
    -- Replace the open functions with our custom ones
    huefy.open = huefy_override.open
    shades.open = shades_override.open
    
    -- Also override the commands if they exist
    if vim.fn.exists(":Huefy") == 2 then
      vim.api.nvim_create_user_command("Huefy", huefy_override.open, { desc = "Enhanced Huefy Color Picker" })
    end
    
    if vim.fn.exists(":Shades") == 2 then
      vim.api.nvim_create_user_command("Shades", shades_override.open, { desc = "Enhanced Shades Color Picker" })
    end
  end, 500) -- Wait a bit for minty to fully load
end

return M
