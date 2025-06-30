-- 🚀 NDE 3.0.0 Renaissance Update: vim-fugitive for ultimate Git control
return {
    {
        "tpope/vim-fugitive",
        cmd = {
            "G", "Git", "Gdiffsplit", "Gread", "Gwrite", "Ggrep",
            "GMove", "GDelete", "GBrowse", "GRemove", "GRename", "Glgrep", "Gedit"
        },
        ft = { "fugitive" },
        keys = {
            { "<leader>gg", "<cmd>Git<cr>", desc = "Git Status" },
            { "<leader>gd", "<cmd>Gdiffsplit<cr>", desc = "Git Diff Split" },
            { "<leader>gb", "<cmd>Git blame<cr>", desc = "Git Blame" },
            { "<leader>gw", "<cmd>Gwrite<cr>", desc = "Git Write (Stage)" },
            { "<leader>gr", "<cmd>Gread<cr>", desc = "Git Read (Checkout)" },
            { "<leader>gc", "<cmd>Git commit<cr>", desc = "Git Commit" },
            { "<leader>gp", "<cmd>Git push<cr>", desc = "Git Push" },
            { "<leader>gP", "<cmd>Git pull<cr>", desc = "Git Pull" },
        },
        config = function()
            -- Configure fugitive settings
            -- Custom keymaps for fugitive buffers
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "fugitive",
                callback = function()
                    local opts = { buffer = true, silent = true }
                    
                    -- Quick navigation
                    vim.keymap.set("n", "q", "<cmd>q<cr>", opts)
                    vim.keymap.set("n", "<Tab>", "=", opts) -- Next file
                    vim.keymap.set("n", "<S-Tab>", "-", opts) -- Previous file
                    
                    -- Stage/unstage shortcuts
                    vim.keymap.set("n", "<Space>", "=", opts) -- Toggle stage/unstage
                    vim.keymap.set("n", "s", "=", opts) -- Stage
                    vim.keymap.set("n", "u", "-", opts) -- Unstage
                    vim.keymap.set("n", "U", "X", opts) -- Unstage all
                    
                    -- Diff and navigation
                    vim.keymap.set("n", "dd", "dv", opts) -- Diff vertical
                    vim.keymap.set("n", "dh", "ds", opts) -- Diff horizontal
                    vim.keymap.set("n", "cc", "cc", opts) -- Commit
                    vim.keymap.set("n", "ca", "ca", opts) -- Commit amend
                end,
            })
            
            -- Auto-close fugitive buffers when not needed
            vim.api.nvim_create_autocmd("BufReadPost", {
                pattern = "fugitive://*",
                callback = function()
                    vim.opt_local.bufhidden = "delete"
                end,
            })
        end,
    }
}
