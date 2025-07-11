return {
    {
        "stevearc/aerial.nvim",
        cmd = "AerialToggle",
        keys = { 
            { "<leader>A", "<cmd>AerialToggle!<CR>", desc = "Toggle Aerial" } 
        },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        },
        config = function()
            require("aerial").setup({
                -- Position the aerial window on the right side
                placement = "edge",
                default_direction = "right",
                
                -- Configure layout
                layout = {
                    min_width = 30,
                    max_width = 30,
                },
                
                -- Show detailed treesitter symbols
                show_guides = true,
                guides = {
                    mid_item = "├─",
                    last_item = "└─",
                    nested_top = "│ ",
                    whitespace = "  ",
                },
                -- Better icons for symbols
                icons = {
                    Class = "󰠱 ",
                    Constructor = " ",
                    Enum = " ",
                    Function = "󰊕 ",
                    Interface = " ",
                    Module = " ",
                    Method = "󰆧 ",
                    Struct = "󰙅 ",
                },
                
                -- Integrate with existing LSP setup
                attach_mode = "global",
                backends = {
                    ["_"] = { "lsp", "treesitter", "markdown", "man" },
                },
                
                -- Performance optimizations
                disable_max_lines = 10000,
                disable_max_size = 2000000, -- 2MB
                
                -- Close aerial when it's the last window
                close_automatic_events = { "unsupported" },
                close_on_select = false,
                
                -- Highlight the current symbol
                highlight_on_hover = true,
                highlight_on_jump = false,
                
                -- Keymaps within the aerial buffer
                keymaps = {
                    ["<CR>"] = "actions.jump",
                    ["<C-v>"] = "actions.jump_vsplit",
                    ["<C-s>"] = "actions.jump_split",
                    ["p"] = "actions.scroll",
                    ["<C-j>"] = "actions.down_and_scroll",
                    ["<C-k>"] = "actions.up_and_scroll",
                },

                filter_kind = false,

                -- Ensure aerial auto-updates
                autojump = false,
                manage_folds = false,
                link_folds_to_tree = false,
                link_tree_to_folds = false,
                treesitter = {
                    update_delay = 300,
                },
                lsp = {
                    update_delay = 300,
                    diagnostics_trigger_update = true,
                },
            })

        end,
    }
}
