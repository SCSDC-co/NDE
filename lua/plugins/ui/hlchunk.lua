return {
  "shellRaining/hlchunk.nvim",
  lazy = true, -- ⚡ PERFORMANCE: Only load when viewing code
  event = { "BufReadPost", "BufNewFile" }, -- Load after buffer is fully loaded
  config = function()
    require("hlchunk").setup {
      indent = {
        enable = true,
        chars = {
          "│",
        },
        style = {
          vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Whitespace")), "fg", "gui"),
        },
        exclude_filetypes = {
          "dashboard",
          "help",
          "lspinfo",
          "packer",
          "checkhealth",
          "man",
          "mason",
          "neo-tree",
        },
      },

      chunk = {
        enable = true,
        style = {
          "#FF9E3B",
        },
        chars = {
          horizontal_line = "─",
          vertical_line = "│",
          left_top = "╭",
          left_bottom = "╰",
          right_arrow = ">",
        },
        exclude_filetypes = {
          "dashboard",
          "help",
          "lspinfo",
          "packer",
          "checkhealth",
          "man",
          "mason",
          "neo-tree",
        },
      },

      line_num = {
        enable = true,
        style = "#FF9E3B",
      },
    }
  end,
}
