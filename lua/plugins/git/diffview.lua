-- 🚀 NDE 3.0.0 Renaissance Update: diffview.nvim for sleek Git diff UI
return {
    {
        "sindrets/diffview.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
        keys = {
            { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "🔍 Open Diffview" },
            { "<leader>gc", "<cmd>DiffviewClose<cr>", desc = "❌ Close Diffview" },
            { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "📊 File History" },
            { "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", desc = "📈 Current File History" },
        },
        config = function()
            require("diffview").setup({
                diff_binaries = false,    -- Show diffs for binaries
                enhanced_diff_hl = false, -- See |diffview-config-enhanced_diff_hl|
                git_cmd = { "git" },      -- The git executable followed by default args.
                hg_cmd = { "hg" },        -- The hg executable followed by default args.
                use_icons = true,         -- Requires nvim-web-devicons
                show_help_hints = true,   -- Show hints for how to open the help panel
                watch_index = true,       -- Update views and index on git index changes.
                icons = {                 -- Only applies when use_icons is true.
                    folder_closed = "",
                    folder_open = "",
                },
                signs = {
                    fold_closed = "",
                    fold_open = "",
                    done = "✓",
                },
                view = {
                    -- Configure the layout and behavior of different types of views.
                    -- Available layouts:
                    --  'diff1_plain'
                    --    |'diff2_horizontal'
                    --    |'diff2_vertical'
                    --    |'diff3_horizontal'
                    --    |'diff3_vertical'
                    --    |'diff3_mixed'
                    --    |'diff4_mixed'
                    -- For more info, see |diffview-config-view.x.layout|.
                    default = {
                        -- Config for changed files, and staged files in diff views.
                        layout = "diff2_horizontal",
                        winbar_info = false,          -- See |diffview-config-view.x.winbar_info|
                    },
                    merge_tool = {
                        -- Config for conflicted files in diff views during a merge or rebase.
                        layout = "diff3_horizontal",
                        disable_diagnostics = true,   -- Temporarily disable diagnostics for conflict buffers while in the view.
                        winbar_info = true,           -- See |diffview-config-view.x.winbar_info|
                    },
                    file_history = {
                        -- Config for changed files in file history views.
                        layout = "diff2_horizontal",
                        winbar_info = false,          -- See |diffview-config-view.x.winbar_info|
                    },
                },
                file_panel = {
                    listing_style = "tree",             -- One of 'list' or 'tree'
                    tree_options = {                    -- Only applies when listing_style is 'tree'
                        flatten_dirs = true,            -- Flatten dirs that only contain one single dir
                        folder_statuses = "only_folded",  -- One of 'never', 'only_folded' or 'always'.
                    },
                    win_config = {                      -- See |diffview-config-win_config|
                        position = "left",
                        width = 35,
                        win_opts = {}
                    },
                },
                file_history_panel = {
                    log_options = {   -- See |diffview-config-log_options|
                        git = {
                            single_file = {
                                diff_merges = "combined",
                            },
                            multi_file = {
                                diff_merges = "first-parent",
                            },
                        },
                        hg = {
                            single_file = {},
                            multi_file = {},
                        },
                    },
                    win_config = {    -- See |diffview-config-win_config|
                        position = "bottom",
                        height = 16,
                        win_opts = {}
                    },
                },
                commit_log_panel = {
                    win_config = {   -- See |diffview-config-win_config|
                        win_opts = {},
                    }
                },
                default_args = {    -- Default args prepended to the arg-list for the listed commands
                    DiffviewOpen = {},
                    DiffviewFileHistory = {},
                },
                hooks = {},          -- See |diffview-config-hooks|
                keymaps = {
                    disable_defaults = false, -- Disable the default keymaps
                    view = {
                        -- The `view` bindings are active in the diff buffers, only when the current
                        -- tabpage is a Diffview.
                        {
                            "n",
                            "<tab>",
                            require("diffview.actions").select_next_entry,
                            { desc = "Open the diff for the next file" }
                        },
                        {
                            "n", 
                            "<s-tab>",
                            require("diffview.actions").select_prev_entry,
                            { desc = "Open the diff for the previous file" }
                        },
                        {
                            "n",
                            "gf",
                            require("diffview.actions").goto_file,
                            { desc = "Open the file in a new split in the previous tabpage" }
                        },
                        {
                            "n",
                            "<C-w><C-f>",
                            require("diffview.actions").goto_file_split,
                            { desc = "Open the file in a new split" }
                        },
                        {
                            "n",
                            "<C-w>gf",
                            require("diffview.actions").goto_file_tab,
                            { desc = "Open the file in a new tabpage" }
                        },
                        {
                            "n",
                            "<leader>e",
                            require("diffview.actions").focus_files,
                            { desc = "Bring focus to the file panel" }
                        },
                        {
                            "n",
                            "<leader>b",
                            require("diffview.actions").toggle_files,
                            { desc = "Toggle the file panel." }
                        },
                        {
                            "n",
                            "g<C-x>",
                            require("diffview.actions").cycle_layout,
                            { desc = "Cycle through available layouts." }
                        },
                        {
                            "n",
                            "[x",
                            require("diffview.actions").prev_conflict,
                            { desc = "In the merge-tool: jump to the previous conflict" }
                        },
                        {
                            "n",
                            "]x",
                            require("diffview.actions").next_conflict,
                            { desc = "In the merge-tool: jump to the next conflict" }
                        },
                        {
                            "n",
                            "<leader>co",
                            require("diffview.actions").conflict_choose("ours"),
                            { desc = "Choose the OURS version of a conflict" }
                        },
                        {
                            "n",
                            "<leader>ct",
                            require("diffview.actions").conflict_choose("theirs"),
                            { desc = "Choose the THEIRS version of a conflict" }
                        },
                        {
                            "n",
                            "<leader>cb",
                            require("diffview.actions").conflict_choose("base"),
                            { desc = "Choose the BASE version of a conflict" }
                        },
                        {
                            "n",
                            "<leader>ca",
                            require("diffview.actions").conflict_choose("all"),
                            { desc = "Choose all the versions of a conflict" }
                        },
                        {
                            "n",
                            "dx",
                            require("diffview.actions").conflict_choose("none"),
                            { desc = "Delete the conflict region" }
                        },
                    },
                    diff1 = {
                        -- Mappings in single pane diff layouts
                        {
                            "n",
                            "g?",
                            require("diffview.actions").help("view"),
                            { desc = "Open the help panel" }
                        },
                    },
                    diff2 = {
                        -- Mappings in 2-way diff layouts
                        {
                            "n",
                            "g?",
                            require("diffview.actions").help("view"),
                            { desc = "Open the help panel" }
                        },
                    },
                    diff3 = {
                        -- Mappings in 3-way diff layouts
                        {
                            { "n", "x" },
                            "2do",
                            require("diffview.actions").diffget("ours"),
                            { desc = "Obtain the diff hunk from the OURS version of the file" }
                        },
                        {
                            { "n", "x" },
                            "3do",
                            require("diffview.actions").diffget("theirs"),
                            { desc = "Obtain the diff hunk from the THEIRS version of the file" }
                        },
                        {
                            "n",
                            "g?",
                            require("diffview.actions").help("view"),
                            { desc = "Open the help panel" }
                        },
                    },
                    diff4 = {
                        -- Mappings in 4-way diff layouts
                        {
                            { "n", "x" },
                            "1do",
                            require("diffview.actions").diffget("base"),
                            { desc = "Obtain the diff hunk from the BASE version of the file" }
                        },
                        {
                            { "n", "x" },
                            "2do",
                            require("diffview.actions").diffget("ours"),
                            { desc = "Obtain the diff hunk from the OURS version of the file" }
                        },
                        {
                            { "n", "x" },
                            "3do",
                            require("diffview.actions").diffget("theirs"),
                            { desc = "Obtain the diff hunk from the THEIRS version of the file" }
                        },
                        {
                            "n",
                            "g?",
                            require("diffview.actions").help("view"),
                            { desc = "Open the help panel" }
                        },
                    },
                    file_panel = {
                        {
                            "n",
                            "j",
                            require("diffview.actions").next_entry,
                            { desc = "Bring the cursor to the next file entry" }
                        },
                        {
                            "n",
                            "<down>",
                            require("diffview.actions").next_entry,
                            { desc = "Bring the cursor to the next file entry" }
                        },
                        {
                            "n",
                            "k",
                            require("diffview.actions").prev_entry,
                            { desc = "Bring the cursor to the previous file entry." }
                        },
                        {
                            "n",
                            "<up>",
                            require("diffview.actions").prev_entry,
                            { desc = "Bring the cursor to the previous file entry." }
                        },
                        {
                            "n",
                            "<cr>",
                            require("diffview.actions").select_entry,
                            { desc = "Open the diff for the selected entry." }
                        },
                        {
                            "n",
                            "o",
                            require("diffview.actions").select_entry,
                            { desc = "Open the diff for the selected entry." }
                        },
                        {
                            "n",
                            "<2-LeftMouse>",
                            require("diffview.actions").select_entry,
                            { desc = "Open the diff for the selected entry." }
                        },
                        {
                            "n",
                            "-",
                            require("diffview.actions").toggle_stage_entry,
                            { desc = "Stage / unstage the selected entry." }
                        },
                        {
                            "n",
                            "S",
                            require("diffview.actions").stage_all,
                            { desc = "Stage all entries." }
                        },
                        {
                            "n",
                            "U",
                            require("diffview.actions").unstage_all,
                            { desc = "Unstage all entries." }
                        },
                        {
                            "n",
                            "X",
                            require("diffview.actions").restore_entry,
                            { desc = "Restore entry to the state on the left side." }
                        },
                        {
                            "n",
                            "L",
                            require("diffview.actions").open_commit_log,
                            { desc = "Open the commit log panel." }
                        },
                        {
                            "n",
                            "zo",
                            require("diffview.actions").open_fold,
                            { desc = "Expand fold" }
                        },
                        {
                            "n",
                            "h",
                            require("diffview.actions").close_fold,
                            { desc = "Collapse fold" }
                        },
                        {
                            "n",
                            "zc",
                            require("diffview.actions").close_fold,
                            { desc = "Collapse fold" }
                        },
                        {
                            "n",
                            "za",
                            require("diffview.actions").toggle_fold,
                            { desc = "Toggle fold" }
                        },
                        {
                            "n",
                            "zR",
                            require("diffview.actions").open_all_folds,
                            { desc = "Expand all folds" }
                        },
                        {
                            "n",
                            "zM",
                            require("diffview.actions").close_all_folds,
                            { desc = "Collapse all folds" }
                        },
                        {
                            "n",
                            "<c-b>",
                            require("diffview.actions").scroll_view(-0.25),
                            { desc = "Scroll the view up" }
                        },
                        {
                            "n",
                            "<c-f>",
                            require("diffview.actions").scroll_view(0.25),
                            { desc = "Scroll the view down" }
                        },
                        {
                            "n",
                            "<tab>",
                            require("diffview.actions").select_next_entry,
                            { desc = "Open the diff for the next file" }
                        },
                        {
                            "n",
                            "<s-tab>",
                            require("diffview.actions").select_prev_entry,
                            { desc = "Open the diff for the previous file" }
                        },
                        {
                            "n",
                            "gf",
                            require("diffview.actions").goto_file,
                            { desc = "Open the file in a new split in the previous tabpage" }
                        },
                        {
                            "n",
                            "<C-w><C-f>",
                            require("diffview.actions").goto_file_split,
                            { desc = "Open the file in a new split" }
                        },
                        {
                            "n",
                            "<C-w>gf",
                            require("diffview.actions").goto_file_tab,
                            { desc = "Open the file in a new tabpage" }
                        },
                        {
                            "n",
                            "i",
                            require("diffview.actions").listing_style,
                            { desc = "Toggle between 'list' and 'tree' views" }
                        },
                        {
                            "n",
                            "f",
                            require("diffview.actions").toggle_flatten_dirs,
                            { desc = "Flatten empty subdirectories in tree listing style." }
                        },
                        {
                            "n",
                            "R",
                            require("diffview.actions").refresh_files,
                            { desc = "Update stats and entries in the file list." }
                        },
                        {
                            "n",
                            "<leader>e",
                            require("diffview.actions").focus_files,
                            { desc = "Bring focus to the file panel" }
                        },
                        {
                            "n",
                            "<leader>b",
                            require("diffview.actions").toggle_files,
                            { desc = "Toggle the file panel" }
                        },
                        {
                            "n",
                            "g<C-x>",
                            require("diffview.actions").cycle_layout,
                            { desc = "Cycle available layouts" }
                        },
                        {
                            "n",
                            "[x",
                            require("diffview.actions").prev_conflict,
                            { desc = "Go to the previous conflict" }
                        },
                        {
                            "n",
                            "]x",
                            require("diffview.actions").next_conflict,
                            { desc = "Go to the next conflict" }
                        },
                        {
                            "n",
                            "g?",
                            require("diffview.actions").help("file_panel"),
                            { desc = "Open the help panel" }
                        },
                    },
                    file_history_panel = {
                        {
                            "n",
                            "g!",
                            require("diffview.actions").options,
                            { desc = "Open the option panel" }
                        },
                        {
                            "n",
                            "<C-A-d>",
                            require("diffview.actions").open_in_diffview,
                            { desc = "Open the entry under the cursor in a diffview" }
                        },
                        {
                            "n",
                            "y",
                            require("diffview.actions").copy_hash,
                            { desc = "Copy the commit hash of the entry under the cursor" }
                        },
                        {
                            "n",
                            "L",
                            require("diffview.actions").open_commit_log,
                            { desc = "Show commit details" }
                        },
                        {
                            "n",
                            "zR",
                            require("diffview.actions").open_all_folds,
                            { desc = "Expand all folds" }
                        },
                        {
                            "n",
                            "zM",
                            require("diffview.actions").close_all_folds,
                            { desc = "Collapse all folds" }
                        },
                        {
                            "n",
                            "j",
                            require("diffview.actions").next_entry,
                            { desc = "Bring the cursor to the next file entry" }
                        },
                        {
                            "n",
                            "<down>",
                            require("diffview.actions").next_entry,
                            { desc = "Bring the cursor to the next file entry" }
                        },
                        {
                            "n",
                            "k",
                            require("diffview.actions").prev_entry,
                            { desc = "Bring the cursor to the previous file entry." }
                        },
                        {
                            "n",
                            "<up>",
                            require("diffview.actions").prev_entry,
                            { desc = "Bring the cursor to the previous file entry." }
                        },
                        {
                            "n",
                            "<cr>",
                            require("diffview.actions").select_entry,
                            { desc = "Open the diff for the selected entry." }
                        },
                        {
                            "n",
                            "o",
                            require("diffview.actions").select_entry,
                            { desc = "Open the diff for the selected entry." }
                        },
                        {
                            "n",
                            "<2-LeftMouse>",
                            require("diffview.actions").select_entry,
                            { desc = "Open the diff for the selected entry." }
                        },
                        {
                            "n",
                            "<c-b>",
                            require("diffview.actions").scroll_view(-0.25),
                            { desc = "Scroll the view up" }
                        },
                        {
                            "n",
                            "<c-f>",
                            require("diffview.actions").scroll_view(0.25),
                            { desc = "Scroll the view down" }
                        },
                        {
                            "n",
                            "<tab>",
                            require("diffview.actions").select_next_entry,
                            { desc = "Open the diff for the next file" }
                        },
                        {
                            "n",
                            "<s-tab>",
                            require("diffview.actions").select_prev_entry,
                            { desc = "Open the diff for the previous file" }
                        },
                        {
                            "n",
                            "gf",
                            require("diffview.actions").goto_file,
                            { desc = "Open the file in a new split in the previous tabpage" }
                        },
                        {
                            "n",
                            "<C-w><C-f>",
                            require("diffview.actions").goto_file_split,
                            { desc = "Open the file in a new split" }
                        },
                        {
                            "n",
                            "<C-w>gf",
                            require("diffview.actions").goto_file_tab,
                            { desc = "Open the file in a new tabpage" }
                        },
                        {
                            "n",
                            "<leader>e",
                            require("diffview.actions").focus_files,
                            { desc = "Bring focus to the file panel" }
                        },
                        {
                            "n",
                            "<leader>b",
                            require("diffview.actions").toggle_files,
                            { desc = "Toggle the file panel" }
                        },
                        {
                            "n",
                            "g<C-x>",
                            require("diffview.actions").cycle_layout,
                            { desc = "Cycle available layouts" }
                        },
                        {
                            "n",
                            "g?",
                            require("diffview.actions").help("file_history_panel"),
                            { desc = "Open the help panel" }
                        },
                    },
                    option_panel = {
                        {
                            "n",
                            "<tab>",
                            require("diffview.actions").select_entry,
                            { desc = "Change the current option" }
                        },
                        {
                            "n",
                            "q",
                            require("diffview.actions").close,
                            { desc = "Close the panel" }
                        },
                        {
                            "n",
                            "g?",
                            require("diffview.actions").help("option_panel"),
                            { desc = "Open the help panel" }
                        },
                    },
                    help_panel = {
                        {
                            "n",
                            "q",
                            require("diffview.actions").close,
                            { desc = "Close help menu" }
                        },
                        {
                            "n",
                            "<esc>",
                            require("diffview.actions").close,
                            { desc = "Close help menu" }
                        },
                    },
                },
            })
        end,
    }
}
