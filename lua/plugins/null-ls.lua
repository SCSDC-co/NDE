-- DISABLED: null-ls can cause diagnostic conflicts
-- We're using only native LSP servers for diagnostics now
return {}

-- Original null-ls config commented out to prevent conflicts:
--[[
return {
  "nvimtools/none-ls.nvim", 
  enabled = false,  -- DISABLED to prevent diagnostic conflicts
  dependencies = {
    "nvim-lua/plenary.nvim",
    "williamboman/mason.nvim",
  },
  config = function()
    -- Configuration disabled
  end,
}
--]]

