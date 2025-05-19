return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = {
    "nvim-tree/nvim-web-devicons"
  },
  config = function()
    -- TRUCCO: override del gruppo 'Directory' (usato per il testo di offset)
    vim.api.nvim_set_hl(0, "Directory", { fg = "#00ff00", bg = "#000000", bold = true })
    vim.api.nvim_set_hl(0, "BufferLineOffsetSeparator", { fg = "#000000", bg = "#000000" })

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
            text = "  FILE EXPLORER", -- tutto maiuscolo + padding
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
          fg = "#000000",
          bg = "#000000",
        },
        separator_selected = {
          fg = "#008b2b",
          bg = "#008b2b",
        },
        separator_visible = {
          fg = "#000000",
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

    -- TAB MAPPINGS
    vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next tab" })
    vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Prev tab" })
  end
}
