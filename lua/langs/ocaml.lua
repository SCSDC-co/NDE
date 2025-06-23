-- OCaml language support configuration
local M = {}

-- OCaml Language Server configuration
M.lsp = {
  name = "ocamllsp",  -- Must match primary provider in nuclear diagnostic system
  cmd = { "ocamllsp" },
  filetypes = { "ocaml", "ml", "mli", "reason", "dune" },
  root_dir = function(fname)
    local util = require("lspconfig.util")
    return util.root_pattern(
      "*.opam",
      "dune-project", 
      "dune-workspace",
      ".git"
    )(fname)
  end,
  settings = {
    ocamllsp = {
      enable_on_type_formatting = true,
      enable_snippets = true,
      enable_code_actions = true,
    }
  },
  capabilities = nil, -- Will be set by main LSP config
  on_attach = function(client, bufnr)
    -- Disable LSP formatting (handled by formatter)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    -- OCaml-specific keymaps
    local opts = { noremap = true, silent = true, buffer = bufnr }
    
    -- Build commands
    vim.keymap.set("n", "<leader>ob", function()
      vim.cmd('terminal dune build')
      vim.cmd('startinsert')
    end, { desc = 'Dune build', buffer = bufnr })
    
    vim.keymap.set("n", "<leader>ot", function()
      vim.cmd('terminal dune test')
      vim.cmd('startinsert')
    end, { desc = 'Dune test', buffer = bufnr })
    
    vim.keymap.set("n", "<leader>or", function()
      vim.cmd('terminal dune exec --')
      vim.cmd('startinsert')
    end, { desc = 'Dune exec', buffer = bufnr })
    
    vim.keymap.set("n", "<leader>oc", function()
      vim.cmd('terminal dune clean')
      vim.cmd('startinsert')
    end, { desc = 'Dune clean', buffer = bufnr })
    
    -- OPAM commands
    vim.keymap.set("n", "<leader>oi", function()
      vim.cmd('terminal opam install .')
      vim.cmd('startinsert')
    end, { desc = 'OPAM install', buffer = bufnr })
    
    vim.keymap.set("n", "<leader>ou", function()
      vim.cmd('terminal opam update')
      vim.cmd('startinsert')
    end, { desc = 'OPAM update', buffer = bufnr })
    
    -- REPL integration
    vim.keymap.set("n", "<leader>ol", function()
      vim.cmd('terminal utop')
      vim.cmd('startinsert')
    end, { desc = 'Start OCaml REPL (utop)', buffer = bufnr })
  end,
}

-- OCaml formatter configuration
M.formatters = { 'ocamlformat' }
M.formatter_opts = {
  ocamlformat = {},  -- Using configuration from ocamlformat.lua
}

-- OCaml-specific autocmds and settings
M.setup = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'ocaml', 'ml', 'mli' },
    callback = function()
      -- OCaml indentation settings
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.expandtab = true
      vim.opt_local.commentstring = "(* %s *)"
      vim.opt_local.smartindent = true
      
      -- Enhanced syntax highlighting
      vim.cmd([[
        syntax match ocamlFunction "\<\([a-z][a-zA-Z0-9_']*\)\s*("he=e-1
        highlight link ocamlFunction Function
        
        syntax match ocamlType "\<\([A-Z][a-zA-Z0-9_']*\)\>"
        highlight link ocamlType Type
        
        syntax match ocamlModule "\<\([A-Z][a-zA-Z0-9_']*\)\."he=e-1
        highlight link ocamlModule PreProc
      ]])
      
      -- Set folding for OCaml files
      vim.opt_local.foldmethod = "indent"
      vim.opt_local.foldenable = false -- Start with folds open
      
      -- Completion settings
      vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
    end,
  })
  
  -- Detect OCaml files
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.ml', '*.mli', 'dune', 'dune-project' },
    callback = function()
      local filename = vim.fn.expand("%:e")
      if filename == "ml" or filename == "mli" then
        vim.bo.filetype = 'ocaml'
      elseif vim.fn.expand("%:t") == "dune" or vim.fn.expand("%:t") == "dune-project" then
        vim.bo.filetype = 'dune'
      end
    end,
  })
  
  -- Add OCaml icon for file explorer
  local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
  if devicons_ok then
    devicons.set_icon({
      ml = {
        icon = "🐫",
        color = "#ec7a08",
        name = "OCaml"
      },
      mli = {
        icon = "🐫",
        color = "#ec7a08",
        name = "OCamlInterface"
      }
    })
  end
  
  -- Lazy load OCaml-related plugins if available
  local lazy_loader = require("utils.lazy_loader")
  lazy_loader.on_filetype({"ocaml"}, function()
    -- Load OCaml treesitter if available
    pcall(function() 
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "ocaml" },
      })
    end)
  end)
  
  -- Add OCaml commands
  vim.api.nvim_create_user_command("OCamlNewModule", function(opts)
    local module_name = opts.args
    if module_name and module_name ~= "" then
      local filename = module_name:lower() .. ".ml"
      local interface = module_name:lower() .. ".mli"
      
      -- Create the implementation file
      local file = io.open(filename, "w")
      if file then
        file:write("(* " .. module_name .. " module implementation *)\n\n")
        file:close()
        
        -- Create the interface file
        local ifile = io.open(interface, "w")
        if ifile then
          ifile:write("(* " .. module_name .. " module interface *)\n\n")
          ifile:close()
        end
        
        -- Open the implementation file
        vim.cmd("edit " .. filename)
      else
        vim.notify("Failed to create module file", vim.log.levels.ERROR)
      end
    else
      vim.notify("Please provide a module name", vim.log.levels.ERROR)
    end
  end, { nargs = 1, desc = "Create a new OCaml module" })
end

-- Mason tools for OCaml
M.mason_tools = {
  lsp = { 'ocamllsp' },
  formatters = { 'ocamlformat' },
  debuggers = {},
}

return M
