-- Nix language support configuration
local M = {}

-- Nix Language Server configuration
M.lsp = {
  name = "nil_ls",  -- Must match primary provider in nuclear diagnostic system
  cmd = { "nil" },
  filetypes = { "nix" },
  root_dir = function(fname)
    local util = require("lspconfig.util")
    return util.root_pattern("flake.nix", "default.nix", "shell.nix", ".git")(fname)
  end,
  settings = {
    ["nil"] = {
      -- Formatting settings
      formatting = {
        command = { "alejandra" }, -- Use alejandra for formatting
      },
      -- Diagnostics settings
      diagnostics = {
        ignored = {},
        excludedFiles = {},
      },
      -- Nix Path
      nix = {
        maxMemoryMB = 4096,  -- Increase if dealing with large Nix projects
        flake = {
          autoArchive = true,
          autoEvalInputs = true,
        },
      },
      -- Completion settings
      completion = {
        nilPath = "nix",
        enabledCompletions = {
          "completions_core",
          "completions_build",
          "completions_options",
          "completions_packages",
          "completions_lib",
          "completions_rfc",
        },
      },
    },
  },
  capabilities = nil, -- Will be set by main LSP config
  on_attach = function(client, bufnr)
    -- Disable LSP formatting (handled by alejandra)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    -- Nix-specific keymaps
    local opts = { noremap = true, silent = true, buffer = bufnr }
    
    -- Build the Nix expression
    vim.keymap.set('n', '<leader>nb', function()
      vim.cmd('terminal nix-build ' .. vim.fn.expand('%'))
      vim.cmd('startinsert')
    end, { desc = 'Nix build', buffer = bufnr })
    
    -- Evaluate the Nix expression
    vim.keymap.set('n', '<leader>ne', function()
      vim.cmd('terminal nix-instantiate --eval ' .. vim.fn.expand('%'))
      vim.cmd('startinsert')
    end, { desc = 'Nix evaluate', buffer = bufnr })
    
    -- Enter a Nix shell
    vim.keymap.set('n', '<leader>ns', function()
      local shell_file = "shell.nix"
      if vim.fn.filereadable(shell_file) == 0 then
        shell_file = "default.nix"
      end
      vim.cmd('terminal nix-shell ' .. shell_file)
      vim.cmd('startinsert')
    end, { desc = 'Nix shell', buffer = bufnr })
    
    -- Flake commands
    vim.keymap.set('n', '<leader>nf', function()
      vim.cmd('terminal nix flake check')
      vim.cmd('startinsert')
    end, { desc = 'Nix flake check', buffer = bufnr })
    
    -- Run nix command
    vim.keymap.set('n', '<leader>nr', function()
      local cmd = vim.fn.input('Nix command: ')
      if cmd and cmd ~= '' then
        vim.cmd('terminal nix ' .. cmd)
        vim.cmd('startinsert')
      end
    end, { desc = 'Run nix command', buffer = bufnr })
    
    -- Format with alejandra
    vim.keymap.set('n', '<leader>nF', function()
      vim.lsp.buf.format({ async = true })
    end, { desc = 'Format Nix file', buffer = bufnr })
  end,
}

-- Nix formatter configuration
M.formatters = { 'alejandra' }
M.formatter_opts = {
  alejandra = {},  -- Using configuration from alejandra.lua
}

-- Nix-specific autocmds and settings
M.setup = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'nix' },
    callback = function()
      -- Nix indentation settings
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.expandtab = true
      vim.opt_local.commentstring = "# %s"
      vim.opt_local.smartindent = true
      
      -- Enhanced syntax highlighting
      vim.cmd([[
        syntax match nixAttribute "\<\([a-zA-Z0-9_]\+\)\s*="he=e-1
        highlight link nixAttribute Identifier
        
        syntax match nixFunction "\<\(builtins\|lib\)\.\w\+"
        highlight link nixFunction Function
        
        syntax match nixPath "\<\(\/nix\/store\/[a-z0-9]\{32\}-[a-zA-Z0-9\._-]\+\)\>"
        highlight link nixPath Comment
      ]])
      
      -- Set folding for Nix files
      vim.opt_local.foldmethod = "indent"
      vim.opt_local.foldenable = false -- Start with folds open
      
      -- Completion settings
      vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
    end,
  })
  
  -- Detect Nix files
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.nix' },
    callback = function()
      vim.bo.filetype = 'nix'
    end,
  })
  
  -- Add Nix icon for file explorer
  local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
  if devicons_ok then
    devicons.set_icon({
      nix = {
        icon = "❄️",
        color = "#7EBAE4",
        name = "Nix"
      }
    })
  end
  
  -- Lazy load Nix-related plugins if available
  local lazy_loader = require("utils.lazy_loader")
  lazy_loader.on_filetype({"nix"}, function()
    -- Load Nix treesitter if available
    pcall(function() 
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "nix" },
      })
    end)
  end)
  
  -- Add Nix commands
  vim.api.nvim_create_user_command("NixFlakeInit", function()
    -- Create a new flake.nix file
    local flake_content = [[
{
  description = "A simple Nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Add your dependencies here
          ];
        };
      });
}
]]
    -- Write the flake.nix file
    local file = io.open("flake.nix", "w")
    if file then
      file:write(flake_content)
      file:close()
      vim.cmd("edit flake.nix")
      vim.notify("Created flake.nix", vim.log.levels.INFO)
    else
      vim.notify("Failed to create flake.nix", vim.log.levels.ERROR)
    end
  end, { desc = "Initialize a new Nix flake" })
  
  vim.api.nvim_create_user_command("NixShellInit", function()
    -- Create a new shell.nix file
    local shell_content = [[
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    # Add your dependencies here
  ];

  shellHook = ''
    echo "Welcome to the Nix development shell!"
  '';
}
]]
    -- Write the shell.nix file
    local file = io.open("shell.nix", "w")
    if file then
      file:write(shell_content)
      file:close()
      vim.cmd("edit shell.nix")
      vim.notify("Created shell.nix", vim.log.levels.INFO)
    else
      vim.notify("Failed to create shell.nix", vim.log.levels.ERROR)
    end
  end, { desc = "Initialize a new Nix shell" })
end

-- Mason tools for Nix
M.mason_tools = {
  lsp = { 'nil_ls' },
  formatters = { 'alejandra' },
  debuggers = {},
}

return M
