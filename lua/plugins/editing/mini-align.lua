return {
  "echasnovski/mini.align",
  keys = {
    { "<leader>Ea", "ga", mode = { "n", "x" }, desc = "Easy Align", remap = true },
    { "<leader>EA", "gA", mode = { "n", "x" }, desc = "Live Easy Align", remap = true },
  },
  config = function()
    require('mini.align').setup({
      -- Module mappings. Use `''` (empty string) to disable one.
      mappings = {
        start = 'ga',
        start_with_preview = 'gA',
      },

      -- Modifiers changing alignment steps and/or options
      -- (using default modifiers - will be automatically populated)
      modifiers = {},

      -- Default options controlling alignment process
      options = {
        split_pattern = '',
        justify_side = 'left',
        merge_delimiter = '',
      },

      -- Default steps performing alignment (if `nil`, default is used)
      steps = {
        pre_split = {},
        split = nil,
        pre_justify = {},
        justify = nil,
        pre_merge = {},
        merge = nil,
      },

      -- Whether to disable showing non-error feedback
      -- This also affects (purely informational) helper messages shown after
      -- idle time if user input is required.
      silent = false,
    })
  end,
}
