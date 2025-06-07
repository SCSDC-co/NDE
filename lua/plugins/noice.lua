return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  config = function()
    require("noice").setup({
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
      },
      notify = {
        enabled = true,
      },
      messages = {
        enabled = true,
        view = "notify",
      },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"]              = true,
          ["cmp.entry.get_documentation"]                 = true,
        },
      },
      presets = {
        bottom_search         = true,
        command_palette       = true,
        long_message_to_split = true,
      },
      vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { bg = "#181616", fg = "#626978" }),
      vim.api.nvim_set_hl(0, "NoiceCmdlineIconCmdline", { bg = "#181616", fg = "#626978" }),
    })
  end,
}
