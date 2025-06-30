-- 🚀 NDE 3.0.0 Renaissance Update: presence.nvim for Discord Rich Presence
return {
    {
        "andweeb/presence.nvim",
        event = "BufReadPost",  -- Load after opening a buffer
        config = function()
            require("presence").setup({
                -- General options
                auto_update         = true,
                neovim_image_text   = "🚀 NDE 3.0.0 - The Renaissance",
                main_image          = "neovim",
                client_id           = "793271441293967371",
                log_level           = nil,  -- No logging for clean experience
                debounce_timeout    = 10,
                enable_line_number  = false,
                blacklist           = {},
                buttons             = false,  -- No buttons for cleaner look
                file_assets         = {},
                show_time           = true,

                -- Rich Presence text options
                editing_text        = "Editing %s",
                file_explorer_text  = "Browsing %s",
                git_commit_text     = "Committing changes",
                plugin_manager_text = "Managing plugins",
                reading_text        = "Reading %s",
                workspace_text      = "🚀 NDE 3.0.0 | %s",
                line_number_text    = "Line %s out of %s",
            })
        end,
    }
}
