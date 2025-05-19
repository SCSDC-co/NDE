return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")

      telescope.setup({
        defaults = {
          hidden = true,
          winblend = 0,
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          prompt_prefix = "🔎 ",
          selection_caret = "➤ ",
          mappings = {
            i = {
              ["<esc>"] = require("telescope.actions").close,
            },
          },
        },
      })

      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          local telescope_highlights = {
            Normal = { bg = "#000000" },
            NormalFloat = { bg = "#000000" },
            FloatBorder = { fg = "#008B2B", bg = "#000000" },
            TelescopeNormal = { bg = "#000000" },
            TelescopePrompt = { bg = "#000000" },
            TelescopePromptBorder = { fg = "#008B2B", bg = "#000000" },
            TelescopePromptTitle = { fg = "#008B2B", bg = "#000000" },
            TelescopeResults = { bg = "#000000", fg = "#008B2B" },
            TelescopeResultsBorder = { fg = "#008B2B", bg = "#000000" },
            TelescopeResultsTitle = { fg = "#008B2B", bg = "#000000" },
            TelescopePreview = { bg = "#000000", fg = "#008B2B" },
            TelescopePreviewBorder = { fg = "#008B2B", bg = "#000000" },
            TelescopePreviewTitle = { fg = "#008B2B", bg = "#000000" },
            Pmenu = { bg = "#000000" },
            PmenuSel = { bg = "#000000" },
            PmenuSbar = { bg = "#000000" },
            PmenuThumb = { bg = "#000000" },
            WinSeparator = { fg = "#008B2B", bg = "#000000" },
          }

          for group, opts in pairs(telescope_highlights) do
            vim.api.nvim_set_hl(0, group, opts)
          end
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "TelescopePreviewerLoaded",
        callback = function(args)
          local win = args.data.win or vim.api.nvim_get_current_win()
          vim.api.nvim_win_set_option(win, "winhl", "Normal:TelescopeNormal")
        end,
      })

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", function()
        builtin.find_files({ hidden = true })
      end, { desc = "Telescope Find Files (All)" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope Live Grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope Buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope Help" })
    end,
  },
}
