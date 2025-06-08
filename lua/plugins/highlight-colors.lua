return {
  "brenoprata10/nvim-highlight-colors",
  event = "VeryLazy",
  config = function()
    require('nvim-highlight-colors').setup({
      ---Render style - 'virtual' for VSCode-like squares
      ---@usage 'background'|'foreground'|'virtual'
      render = 'virtual',

      ---Set virtual symbol (small square like VSCode)
      virtual_symbol = '■',

      ---Set virtual symbol prefix (space before the square)
      virtual_symbol_prefix = ' ',

      ---Set virtual symbol suffix (no space after)
      virtual_symbol_suffix = '',

      ---Set virtual symbol position - 'inline' for VSCode style
      ---@usage 'inline'|'eol'|'eow'
      ---inline mimics VS Code style perfectly
      virtual_symbol_position = 'inline',

      ---Highlight hex colors, e.g. '#FFFFFF'
      enable_hex = true,

      ---Highlight short hex colors e.g. '#fff'
      enable_short_hex = true,

      ---Highlight rgb colors, e.g. 'rgb(0 0 0)'
      enable_rgb = true,

      ---Highlight hsl colors, e.g. 'hsl(150deg 30% 40%)'
      enable_hsl = true,

      ---Highlight CSS variables, e.g. 'var(--testing-color)'
      enable_var_usage = true,

      ---Highlight named colors, e.g. 'green'
      enable_named_colors = true,

      ---Highlight tailwind colors, e.g. 'bg-blue-500'
      enable_tailwind = true,

      ---Set custom colors for CSS variables
      ---Label must be properly escaped with '%' to adhere to `string.gmatch`
      --- :help string.gmatch
      custom_colors = {
        { label = '%-%-theme%-primary%-color',   color = '#0f1419' },
        { label = '%-%-theme%-secondary%-color', color = '#5a5a5a' },
        { label = '%-%-kanagawa%-bg',            color = '#181616' },
        { label = '%-%-kanagawa%-fg',            color = '#dcd7ba' },
      }
    })
  end,
}

