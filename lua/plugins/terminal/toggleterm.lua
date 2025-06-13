return {
  "akinsho/toggleterm.nvim",
  lazy = true, -- ⚡ PERFORMANCE: Only load when needed
  keys = {
    { "<F12>", desc = "Toggle Terminal" },
    { "<F11>", desc = "Toggle Lazygit" },
  },
  cmd = { "ToggleTerm", "TermExec" },
  version = "*",
  config = function()
    vim.cmd([[highlight ToggleTermBG guibg=#181616]])

    local toggleterm = require("toggleterm")
    toggleterm.setup({
      size = 70,
      open_mapping = false,
      direction = "vertical",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        highlights = {
          Normal      = { guibg = "#181616" },
          NormalFloat = { guibg = "#181616" },
          FloatBorder = { guibg = "#181616" },
        },
      },
      highlights = {
        Normal      = { guibg = "#181616" },
        NormalFloat = { guibg = "#181616" },
        FloatBorder = { guibg = "#181616" },
      },
    })

    local Terminal = require("toggleterm.terminal").Terminal

    local function apply_toggleterm_bg()
      vim.api.nvim_win_set_option(0, "winhighlight",
        "Normal:ToggleTermBG,LineNr:ToggleTermBG,SignColumn:ToggleTermBG,CursorLineNr:ToggleTermBG"
      )
    end

    local right_term = Terminal:new({
      direction = "vertical",
      close_on_exit = true,
      count = 99,
    })
    function _right_term_toggle()
      right_term:toggle()
      vim.cmd("wincmd l")
      vim.cmd("startinsert")
      apply_toggleterm_bg()
    end

    local lazygit = Terminal:new({
      cmd = "lazygit",
      direction = "vertical",
      close_on_exit = true,
      count = 100,
    })
    function _lazygit_toggle()
      lazygit:toggle()
      vim.cmd("wincmd l")
      vim.cmd("startinsert")
      apply_toggleterm_bg()
    end

    vim.keymap.set("n", "<F12>", _right_term_toggle, { noremap = true, silent = true })
    vim.keymap.set("n", "<F11>", _lazygit_toggle,  { noremap = true, silent = true })
  end,
}
