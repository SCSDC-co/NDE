local M = {}

-- Setup treesitter with default configuration
function M.setup(config)
  require("nvim-treesitter.configs").setup({
    -- Install parsers on-demand via OptiSpec language modules
    ensure_installed = {},
    
    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,
    
    -- Automatically install missing parsers when entering buffer
    auto_install = false, -- OptiSpec handles this
    
    highlight = {
      enable = true,
      
      -- Disable slow treesitter highlight for large files
      disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,
      
      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      additional_vim_regex_highlighting = false,
    },
    
    indent = {
      enable = true
    },
    
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },
  })
  
  -- Store treesitter utilities globally
  _G.OptiSpec = _G.OptiSpec or {}
  _G.OptiSpec.treesitter = {
    install_parser = M.install_parser,
    is_parser_installed = M.is_parser_installed,
  }
end

-- Install a treesitter parser
function M.install_parser(parser_name)
  local parsers = require("nvim-treesitter.parsers")
  
  if not parsers.has_parser(parser_name) then
    vim.cmd("TSInstall " .. parser_name)
    return true
  end
  
  return false -- Already installed
end

-- Check if parser is installed
function M.is_parser_installed(parser_name)
  local parsers = require("nvim-treesitter.parsers")
  return parsers.has_parser(parser_name)
end

-- Install multiple parsers
function M.install_parsers(parsers)
  for _, parser in ipairs(parsers) do
    M.install_parser(parser)
  end
end

-- Plugin definitions
M.plugins = {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    config = function()
      M.setup({})
    end
  }
}

return M
