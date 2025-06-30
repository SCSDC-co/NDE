-- 🚀 NDE 3.0.0 Renaissance Update: refactoring.nvim for LSP-powered refactoring
return {
    {
        "ThePrimeagen/refactoring.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        cmd = { "Refactor" },
        keys = {
            -- Extract function supports only visual mode
            {
                "<leader>re",
                function() require('refactoring').refactor('Extract Function') end,
                mode = "x",
                desc = "🔧 Extract Function",
            },
            {
                "<leader>rf",
                function() require('refactoring').refactor('Extract Function To File') end,
                mode = "x", 
                desc = "📄 Extract Function To File",
            },
            -- Extract variable supports only visual mode
            {
                "<leader>rv",
                function() require('refactoring').refactor('Extract Variable') end,
                mode = "x",
                desc = "📝 Extract Variable",
            },
            -- Inline func supports only normal mode
            {
                "<leader>rI",
                function() require('refactoring').refactor('Inline Function') end,
                mode = "n",
                desc = "🔄 Inline Function",
            },
            -- Inline var supports both normal and visual mode
            {
                "<leader>ri",
                function() require('refactoring').refactor('Inline Variable') end,
                mode = { "n", "x" },
                desc = "🔗 Inline Variable",
            },
            -- Extract block supports only normal mode
            {
                "<leader>rb",
                function() require('refactoring').refactor('Extract Block') end,
                mode = "n",
                desc = "🧱 Extract Block",
            },
            {
                "<leader>rbf",
                function() require('refactoring').refactor('Extract Block To File') end,
                mode = "n",
                desc = "📦 Extract Block To File",
            },
            -- Prompt for refactor to get the list of available refactors
            {
                "<leader>rr",
                function() require('refactoring').select_refactor() end,
                mode = { "n", "x" },
                desc = "🎯 Select Refactor",
            },
            -- Debug refactors
            {
                "<leader>rp",
                function() require('refactoring').debug.printf({below = false}) end,
                mode = "n",
                desc = "🐛 Debug Print",
            },
            {
                "<leader>rv",
                function() require('refactoring').debug.print_var({normal_mode_only = true}) end,
                mode = { "x", "n" },
                desc = "🔍 Debug Print Var",
            },
            {
                "<leader>rc",
                function() require('refactoring').debug.cleanup({}) end,
                mode = "n",
                desc = "🧹 Cleanup Debug Prints",
            },
        },
        config = function()
            require('refactoring').setup({
                -- prompt for return type
                prompt_func_return_type = {
                    go = false,
                    java = false,
                    cpp = false,
                    c = false,
                    h = false,
                    hpp = false,
                    cxx = false,
                },
                -- prompt for function parameters
                prompt_func_param_type = {
                    go = false,
                    java = false,
                    cpp = false,
                    c = false,
                    h = false,
                    hpp = false,
                    cxx = false,
                },
                printf_statements = {},
                print_var_statements = {},
                show_success_message = true, -- shows a message with information about the refactor on success
                                            -- i.e. [Refactor] Inlined 3 variable occurrences
            })

            -- You can also use below = true here to to change the position of the printf
            -- statement (or set two keymaps for either one). This also fixes the boolean parameter
            require('refactoring').setup({
                -- overrides extract function behavior
                extract_var_statements = {
                    go = "%s := %s // log output",
                },
                -- overrides extract function behavior  
                printf_statements = {
                    -- add a custom printf statement for cpp
                    cpp = {
                        'std::cout << "%s" << std::endl;'
                    },
                    -- add a custom printf statement for javascript
                    javascript = {
                        'console.log("%s");'
                    },
                    -- add a custom printf statement for typescript
                    typescript = {
                        'console.log("%s");'
                    },
                    -- add a custom printf statement for python
                    python = {
                        'print(f"%s")'
                    },
                    -- add a custom printf statement for lua
                    lua = {
                        'print("%s")'
                    },
                    -- add a custom printf statement for java
                    java = {
                        'System.out.println("%s");'
                    },
                },
                -- overrides the default behavior, useful when the binop is not substituted
                print_var_statements = {
                    -- add a custom print var statement for cpp
                    cpp = {
                        'std::cout << "%s " << %s << std::endl;'
                    },
                    -- add a custom print var statement for javascript  
                    javascript = {
                        'console.log("%s", %s);'
                    },
                    -- add a custom print var statement for typescript
                    typescript = {
                        'console.log("%s", %s);'
                    },
                    -- add a custom print var statement for python
                    python = {
                        'print(f"%s {%s}")'
                    },
                    -- add a custom print var statement for lua
                    lua = {
                        'print("%s", %s)'
                    },
                    -- add a custom print var statement for java
                    java = {
                        'System.out.println("%s " + %s);'
                    },
                },
            })
        end,
    }
}
