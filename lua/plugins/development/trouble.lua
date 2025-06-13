return {
  "folke/trouble.nvim",
  lazy = true, -- ⚡ PERFORMANCE: Only load when viewing diagnostics
  cmd = { "Trouble", "TroubleToggle", "TroubleClose", "TroubleRefresh" },
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    require("trouble").setup({
      position = "bottom",
      height = 10,
      icons = true,
      mode = "workspace_diagnostics",
      fold_open = "",
      fold_closed = "",
      group = true,
      padding = true,
      action_keys = {
        close = "q",
        cancel = "<esc>",
        refresh = "r",
        jump = {"<cr>", "<tab>"},
        open_split = { "<c-x>" },
        open_vsplit = { "<c-v>" },
        open_tab = { "<c-t>" },
        toggle_mode = "m",
        toggle_preview = "P",
        hover = "K",
        preview = "p",
        previous = "k",
        next = "j"
      },
    })
  end,
}

