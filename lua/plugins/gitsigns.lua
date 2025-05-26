return {
  "lewis6991/gitsigns.nvim",
  lazy = false,
  config = function()
    vim.o.termguicolors = true

    require('gitsigns').setup {
      signs = {
        add          = {hl = 'GitSignsAdd', text = '│', numhl='GitSignsAddNr', linehl='GitSignsAddLn'},
        change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
        delete       = {hl = 'GitSignsDelete', text = '|', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
        topdelete    = {hl = 'GitSignsDelete', text = '|', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
        changedelete = {hl = 'GitSignsChange', text = '|', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
      },
      numhl = false,
      linehl = false,
      keymaps = {},
      watch_gitdir = { interval = 1000 },
      sign_priority = 6,
      update_debounce = 200,
      status_formatter = nil,
    }

    vim.cmd [[
      highlight Normal       guibg=#000000
      highlight LineNr       guibg=#000000
      highlight SignColumn   guibg=#000000
      highlight GitSignsAdd    guifg=#008b2b guibg=NONE
      highlight GitSignsChange guifg=#ff9900 guibg=NONE
      highlight GitSignsDelete guifg=#ff0000 guibg=NONE
    ]]

    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = function()
        vim.cmd [[
          highlight Normal       guibg=#000000
          highlight LineNr       guibg=#000000
          highlight SignColumn   guibg=#000000
          highlight GitSignsAdd    guifg=#008b2b guibg=NONE
          highlight GitSignsChange guifg=#ff9900 guibg=NONE
          highlight GitSignsDelete guifg=#ff0000 guibg=NONE
        ]]
      end
    })
  end
}
