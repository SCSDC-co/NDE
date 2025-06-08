return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    delay = 1000,  -- Increased delay to avoid interfering with Codeium
    expand = 1,
    notify = true,
    
    -- Plugins
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = true,
        suggestions = 20,
      },
      presets = {
        operators = true,  -- Re-enable operators to fix Codeium interference
        motions = true,
        text_objects = true,
        windows = true,
        nav = true,
        z = true,
        g = true,
      },
    },
    
    -- Window settings
    win = {
      border = "rounded",
      padding = { 1, 2 },
      wo = {
        winblend = 0,
      },
    },
    
    -- Layout settings
    layout = {
      height = { min = 4, max = 25 },
      width = { min = 20, max = 50 },
      spacing = 3,
      align = "left",
    },
    
    -- Key mappings
    keys = {
      scroll_down = "<c-d>",
      scroll_up = "<c-u>",
    },
    
    -- Sorting and filtering
    sort = { "local", "order", "group", "alphanum", "mod" },
    expand = 0,
    
    -- Icons
    icons = {
      breadcrumb = "»",
      separator = "➜",
      group = "+",
      ellipsis = "…",
      mappings = true,
      rules = {},
      colors = true,
      keys = {
        Up = " ",
        Down = " ",
        Left = " ",
        Right = " ",
        C = "󰘴 ",
        M = "󰘵 ",
        D = "󰘳 ",
        S = "󰘴 ",
        CR = "󰌑 ",
        Esc = "󱊷 ",
        ScrollWheelDown = "󰍽 ",
        ScrollWheelUp = "󰍾 ",
        NL = "󰌑 ",
        BS = "󰁮",
        Space = "󱁐 ",
        Tab = "󰌒 ",
        F1 = "󱊫",
        F2 = "󱊬",
        F3 = "󱊭",
        F4 = "󱊮",
        F5 = "󱊯",
        F6 = "󱊰",
        F7 = "󱊱",
        F8 = "󱊲",
        F9 = "󱊳",
        F10 = "󱊴",
        F11 = "󱊵",
        F12 = "󱊶",
      },
    },
    
    show_help = true,
    show_keys = true,
    disable = {
      buftypes = {},
      filetypes = { "TelescopePrompt", "alpha" },
    },
    
    -- Key mappings definitions
    spec = {
      -- Leader mappings
      { "<leader>f", group = "🔍 Find" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
      
      { "<leader>e", function()
        local neotree_win = nil
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
          if bufname:match("neo%-tree filesystem") then
            neotree_win = win
            break
          end
        end
        if neotree_win then
          vim.cmd("Neotree close")
        else
          require("neo-tree.command").execute({ source = "filesystem", dir = "/" })
        end
      end, desc = "🌲 File Explorer (Root)" },
      { "<leader>n", function()
        local neotree_win = nil
        local current_win = vim.api.nvim_get_current_win()
        local last_win = vim.g.neotree_last_win
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
          if bufname:match("neo%-tree filesystem") then
            neotree_win = win
            break
          end
        end
        if neotree_win then
          if current_win == neotree_win then
            if last_win and vim.api.nvim_win_is_valid(last_win) then
              vim.api.nvim_set_current_win(last_win)
            else
              vim.cmd("wincmd p")
            end
          else
            vim.g.neotree_last_win = current_win
            vim.api.nvim_set_current_win(neotree_win)
          end
        else
          vim.g.neotree_last_win = current_win
          require("neo-tree.command").execute({ source = "filesystem", dir = "/" })
        end
      end, desc = "📁 Toggle between Neotree and file" },
      
      { "<leader>b", group = "📋 Buffer" },
      { "<leader>bc", "<cmd>bdelete<cr>", desc = "Close Buffer" },
      { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Close Others" },
      
      { "<leader>g", group = "🤖 AI" },
      { "<leader>ge", ":GpExplain<cr>", desc = "Explain Code", mode = "v" },
      { "<leader>gr", ":GpRewrite<cr>", desc = "Rewrite Code", mode = "v" },
      { "<leader>gc", ":GpChatNew<cr>", desc = "New Chat" },
      
      { "<leader>d", group = "🐛 Debug" },
      { "<leader>du", function() require('dapui').toggle() end, desc = "Toggle DAP UI" },
      
      { "<leader>j", "<cmd>call append(line('.'), '')<cr>", desc = "➕ Insert Line Below" },
      { "<leader>k", "<cmd>call append(line('.') - 1, '')<cr>", desc = "➕ Insert Line Above" },
      
      -- Function keys
      { "<F1>", desc = "🔴 Toggle Breakpoint" },
      { "<F2>", desc = "▶️ Debug Continue" },
      { "<F3>", desc = "⬇️ Debug Step Into" },
      { "<F4>", desc = "➡️ Debug Step Over" },
      { "<F5>", desc = "🐍 Run Python" },
      { "<F6>", desc = "⚡ Compile & Run C++" },
      { "<F7>", desc = "🔧 Compile & Run C" },
      { "<F8>", desc = "⚙️ Assemble & Run ASM" },
    },
  },
  
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    
    vim.cmd([[
      highlight WhichKey guifg=#dcd7ba guibg=#181616
      highlight WhichKeyGroup guifg=#7e9cd8 guibg=#181616
      highlight WhichKeyDesc guifg=#a3d4d5 guibg=#181616
      highlight WhichKeyValue guifg=#a3d4d5 guibg=#181616
      highlight WhichKeySeparator guifg=#54546d guibg=#181616
      highlight WhichKeyFloat guibg=#181616
      highlight WhichKeyBorder guifg=#54546d guibg=#181616
      highlight WhichKeyTitle guifg=#7e9cd8 guibg=#181616
      highlight WhichKeyNormal guibg=#181616
    ]])
  end,
}

