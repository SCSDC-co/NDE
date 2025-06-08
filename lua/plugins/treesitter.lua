return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          -- Systems Programming
          "c", "cpp", "rust", "zig", "go", "c_sharp", "asm",
          
          -- Web Development  
          "javascript", "typescript", "tsx", "html", "css", "scss",
          "vue", "svelte", "astro", "php",
          
          -- Scripting & Config
          "lua", "python", "bash", "fish", "powershell",
          
          -- Data & Markup
          "json", "yaml", "toml", "xml", "markdown", "markdown_inline",
          
          -- Other Languages
          "java", "kotlin", "scala", "haskell", "ocaml", "elixir", "erlang",
          "ruby", "perl", "r", "julia", "dart",
          
          -- DevOps & Tools
          "dockerfile", "terraform", "hcl", "nix", "cmake", "make",
          
          -- Database
          "sql", "prisma",
          
          -- Misc
          "vim", "vimdoc", "regex", "gitignore", "gitcommit", "diff",
        },
        highlight = { 
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<CR>",
            node_incremental = "<CR>",
            scope_incremental = "<S-CR>",
            node_decremental = "<BS>",
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["al"] = "@loop.outer",
              ["il"] = "@loop.inner",
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
            },
          },
        },
        fold = {
          enable = true,
        },

        playground = {
          enable = true,
          updatetime = 25,
          persist_queries = false,
        },
      })
    end,
  },
  {
    "nvim-treesitter/playground",
    cmd = "TSPlaygroundToggle",
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require('treesitter-context').setup({
        enable = true,
        max_lines = 0,
        min_window_height = 0,
        line_numbers = true,
        multiline_threshold = 20,
        trim_scope = 'outer',
        mode = 'cursor',
        separator = nil,
      })
    end,
  },
}
