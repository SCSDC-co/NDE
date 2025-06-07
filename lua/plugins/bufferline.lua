return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = {
    "nvim-tree/nvim-web-devicons"
  },
  config = function()
    vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
      callback = function()
        vim.api.nvim_set_hl(0, "BufferLineOffset", { bg = "#0d0c0c", fg = "#8BA4B0", bold = true })
        vim.api.nvim_set_hl(0, "BufferLineOffsetSeparator", { bg = "#0d0c0c", fg = "#0d0c0c" })
      end,
    })

    require("bufferline").setup({
      options = {
        mode = "buffers",
        diagnostics = "nvim_lsp",
        show_buffer_close_icons = true,
        show_close_icon = false,
        separator_style = "thin",
        always_show_bufferline = true,
        offsets = {
          {
            filetype = "neo-tree",
            text = " NeoTree",
            text_align = "left",
            separator = true,
            highlight = "BufferLineOffset",
            separator_highlight = "BufferLineOffsetSeparator",
            style = "bold",
          },
        },
      },
    })

    vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next tab" })
    vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Prev tab" })
  end,
}
