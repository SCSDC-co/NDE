-- This file configures additional snacks.animate features
-- Main snacks.nvim is configured in lua/plugins/core/snacks.lua

return {
    "folke/snacks.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
        -- Extend the existing snacks configuration with animate features
        opts = opts or {}
        
        -- Enable animate module
opts.animate = {
            enabled = true,
            duration = 200,
            easing = "linear",
            fps = 60,
            filter = function(buf)
                return vim.bo[buf].filetype ~= "neo-tree"
            end,
        }
        
        return opts
    end,
}

