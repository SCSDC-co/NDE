-- 🚀 NDE 3.0.0 Renaissance Update: tabout.nvim for smart tab-out behavior
return {
    {
        'abecodes/tabout.nvim',
        event = 'InsertEnter', -- Load only when entering insert mode
        priority = 1000,
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'hrsh7th/nvim-cmp', -- Optional, better compatibility with completion
        },
        config = function()
            require('tabout').setup({
                tabkey = '<Tab>', -- key to trigger tabout, set to an empty string to disable
                backwards_tabkey = '<S-Tab>', -- key to trigger backwards tabout, set to an empty string to disable
                act_as_tab = true, -- shift content if tab out is not possible
                act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
                default_tab = '<C-t>', -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
                default_shift_tab = '<C-d>', -- reverse shift default action,
                enable_backwards = true, -- well ...
                completion = false, -- if the tabkey is used in a completion pum
                tabouts = {
                    {open = "'", close = "'"},
                    {open = '"', close = '"'},
                    {open = '`', close = '`'},
                    {open = '(', close = ')'},
                    {open = '[', close = ']'},
                    {open = '{', close = '}'},
                    {open = '<', close = '>', only_at_beginning = true},
                },
                ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
                exclude = {} -- tabout will ignore these filetypes
            })
        end,
    }
}
