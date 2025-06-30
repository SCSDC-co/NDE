return {
  "junegunn/vim-easy-align",
  keys = {
    { "<leader>Ea", "<Plug>(EasyAlign)", mode = { "n", "x" }, desc = "Easy Align" },
    { "<leader>EA", "<Plug>(LiveEasyAlign)", mode = { "n", "x" }, desc = "Live Easy Align" },
  },
  config = function()
    -- Custom alignment rules
    vim.g.easy_align_delimiters = {
      ['>'] = { pattern = '>>', left_margin = 1, right_margin = 1, stick_to_left = 0 },
      ['/'] = { pattern = [[//\+\|/\*\|\*/]], left_margin = 1, right_margin = 1 },
      [']'] = {
        pattern = [=[[\]]=], left_margin = 1, right_margin = 0, stick_to_left = 0
      },
      [')'] = {
        pattern = '[()]', left_margin = 1, right_margin = 0, stick_to_left = 0
      },
      ['d'] = {
        pattern = ' \\(\\S\\+\\s*[;=]\\)\\@=', left_margin = 0, right_margin = 0
      }
    }
  end,
}
