return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = {
    "nvim-tree/nvim-web-devicons"
  },
  config = function()
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
            text = "  FILE EXPLORER",
            text_align = "left",
            separator = true,
          }
        },
      },
      highlights = {
        fill = {
          bg = "#000000",
        },
        background = {
          fg = "#008b2b",
          bg = "#000000",
        },
        buffer_visible = {
          fg = "#008b2b",
          bg = "#000000",
        },
        buffer_selected = {
          fg = "#202126",
          bg = "#008b2b",
          bold = true,
          italic = false,
        },
        indicator_selected = {
          fg = "#008b2b",
          bg = "#008b2b",
        },
        modified = {
          fg = "#008b2b",
          bg = "#000000",
        },
        modified_selected = {
          fg = "#202126",
          bg = "#008b2b",
        },
        modified_visible = {
          fg = "#008b2b",
          bg = "#000000",
        },
        close_button = {
          fg = "#008b2b",
          bg = "#000000",
        },
        close_button_selected = {
          fg = "#202126",
          bg = "#008b2b",
        },
        close_button_visible = {
          fg = "#008b2b",
          bg = "#000000",
        },
        separator = {
          fg = "#008b2b",
          bg = "#000000",
        },
        separator_selected = {
          fg = "#008b2b",
          bg = "#000000",
        },
        separator_visible = {
          fg = "#008b2b",
          bg = "#000000",
        },
        diagnostic_selected = {
          fg = "#202126",
          bg = "#008b2b",
        },
        hint_selected = {
          fg = "#202126",
          bg = "#008b2b",
        },
        error_selected = {
          fg = "#202126",
          bg = "#008b2b",
        },
        warning_selected = {
          fg = "#202126",
          bg = "#008b2b",
        },
        info_selected = {
          fg = "#202126",
          bg = "#008b2b",
        },
      },
    })

    vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next tab" })
    vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Prev tab" })
  end
}
