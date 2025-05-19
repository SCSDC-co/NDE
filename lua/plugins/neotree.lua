return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  lazy = false,
  config = function()

    -- Forza bianco sui nomi e icone di file e cartelle, niente background
    vim.api.nvim_set_hl(0, "NeoTreeDirectoryName", { fg = "#FFFFFF", bg = "NONE" })
    vim.api.nvim_set_hl(0, "NeoTreeDirectoryIcon", { fg = "#FFFFFF", bg = "NONE" })
    vim.api.nvim_set_hl(0, "Directory", { fg = "#FFFFFF", bg = "NONE" })
    vim.api.nvim_set_hl(0, "NeoTreeFileName", { fg = "#FFFFFF", bg = "NONE" })
    vim.api.nvim_set_hl(0, "NeoTreeFileNameOpened", { fg = "#FFFFFF", bg = "NONE" })
    vim.api.nvim_set_hl(0, "NeoTreeIndentMarker", { fg = "#FFFFFF", bg = "NONE" })

    require("neo-tree").setup({
      close_if_last_window = true,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      default_component_configs = {
        indent = {
          with_markers = true,
          highlight = "NeoTreeIndentMarker",
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "",
          default = "",
        },
        name = {
          trailing_slash = false,
          use_git_status_colors = false,
        },
        git_status = {
          symbols = {
            added     = "",
            modified  = "",
            deleted   = "",
            renamed   = "➜",
            untracked = "★",
            ignored   = "◌",
            unstaged  = "✗",
            staged    = "✓",
            conflict  = "",
          },
        },
      },
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        hijack_netrw_behavior = "open_default",
        group_empty_dirs = true,
        bind_to_cwd = true,
        cwd_target = {
          sidebar = "tab",
          current = "window"
        },
      },
      window = {
        position = "left",
        width = 30,
        mappings = {
          ["o"] = "open",
          ["<CR>"] = "open",
          ["l"] = "open",
          ["h"] = "close_node",
          ["v"] = "open_vsplit",
          ["s"] = "open_split",
          ["t"] = "open_tabnew",
          ["a"] = "add",
          ["d"] = "delete",
          ["r"] = "rename",
          ["R"] = "refresh",
          ["q"] = "close_window",
        },
      },
      event_handlers = {
        {
          event = "neo_tree_buffer_enter",
          handler = function()
            vim.opt_local.signcolumn = "auto"
          end,
        },
      },
    })
  end
}
