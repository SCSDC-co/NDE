-- Docker language support configuration and plugin specification

-- Plugin specification
local plugin_spec = {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "nvim-treesitter/nvim-treesitter",
    {
      -- Hadolint integration for linting Dockerfiles
      "dense-analysis/ale",
      ft = { "dockerfile" },
      config = function()
        vim.g.ale_linters = {
          dockerfile = { 'hadolint' },
        }
        vim.g.ale_dockerfile_hadolint_options = ''
        vim.g.ale_lint_on_text_changed = 'never'
        vim.g.ale_lint_on_insert_leave = 0
        vim.g.ale_lint_on_enter = 0
        vim.g.ale_lint_on_save = 1
        vim.g.ale_fix_on_save = 0
      end,
    },
  },
  ft = {
    "dockerfile",
    "docker-compose.yaml",
    "docker-compose.yml",
  },
  config = function()
    -- Ensure treesitter parsers are installed
    local treesitter = require("nvim-treesitter.configs")
    
    treesitter.setup {
      ensure_installed = {
        "dockerfile",
        "yaml",
      },
    }
    
    -- Docker language server setup
    local lspconfig = require("lspconfig")
    local util = require("lspconfig.util")
    
    -- Configure Docker language server
    lspconfig.dockerls.setup({
      -- Detect project root
      root_dir = util.root_pattern("Dockerfile", "docker-compose.yml", "docker-compose.yaml", ".git"),
      
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
      
      on_attach = function(client, bufnr)
        -- LSP keybindings
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
        vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set("n", "<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
        vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
        vim.keymap.set("n", "<leader>f", function()
          vim.lsp.buf.format({ async = true })
        end, bufopts)
        
        -- Docker-specific keymaps
        vim.keymap.set("n", "<leader>dl", function()
          vim.cmd("ALELint")
        end, { buffer = bufnr, desc = "Lint Dockerfile with hadolint" })
        
        -- Notify performance framework that Docker is loaded
        local dynamic_loader = require('performance.dynamic_loader')
        if dynamic_loader and dynamic_loader.register_plugin then
          dynamic_loader.register_plugin("dockerls", "languages")
        end
      end,
    })
    
    -- Configure Docker Compose language server
    lspconfig.docker_compose_language_service.setup({
      filetypes = { "yaml.docker-compose", "yml.docker-compose" },
      root_dir = util.root_pattern("docker-compose.yml", "docker-compose.yaml", "compose.yml", "compose.yaml"),
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
    })
  end,
}

-- Language configuration
local M = {}

-- Docker Language Server configuration
M.lsp = {
  name = "dockerls",
  -- Configuration handled by the plugin setup
}

-- Docker linter configuration (no real formatter for Dockerfiles)
M.linters = { 'hadolint' }
M.formatters = { }  -- No formatter, only linter

-- Docker-specific autocmds and settings
M.setup = function()
  -- Detect Docker files and apply settings
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'dockerfile', 'yaml.docker-compose' },
    callback = function()
      -- Docker-specific settings
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.expandtab = true
      vim.opt_local.commentstring = "# %s"
      
      -- Docker-specific abbreviations and snippets
      if vim.bo.filetype == "dockerfile" then
        vim.cmd("iabbrev <buffer> dfrom FROM")
        vim.cmd("iabbrev <buffer> drun RUN")
        vim.cmd("iabbrev <buffer> dcmd CMD")
        vim.cmd("iabbrev <buffer> dent ENTRYPOINT")
        vim.cmd("iabbrev <buffer> denv ENV")
        vim.cmd("iabbrev <buffer> dexp EXPOSE")
        vim.cmd("iabbrev <buffer> dadd ADD")
        vim.cmd("iabbrev <buffer> dcpy COPY")
        vim.cmd("iabbrev <buffer> dvol VOLUME")
        vim.cmd("iabbrev <buffer> dwork WORKDIR")
        vim.cmd("iabbrev <buffer> darg ARG")
        vim.cmd("iabbrev <buffer> dlabel LABEL")
        vim.cmd("iabbrev <buffer> duser USER")
        
        -- Add snippet for common Docker patterns
        vim.cmd([[
          inoremap <buffer> <expr> dbase '# Base image<CR>FROM '
          inoremap <buffer> <expr> dstage '# Build stage<CR>FROM '
          inoremap <buffer> <expr> dinstall 'RUN apt-get update && apt-get install -y \'
          inoremap <buffer> <expr> dapk 'RUN apk add --no-cache '
        ]])
      end
      
      -- For docker-compose files (YAML)
      if vim.bo.filetype == "yaml.docker-compose" then
        vim.cmd("iabbrev <buffer> dserv services:")
        vim.cmd("iabbrev <buffer> dvols volumes:")
        vim.cmd("iabbrev <buffer> dnet networks:")
        
        -- Add docker-compose snippets
        vim.cmd([[
          inoremap <buffer> <expr> dservice 'services:<CR>  app:<CR>    image: '
          inoremap <buffer> <expr> dbuild 'build:<CR>      context: .<CR>      dockerfile: Dockerfile'
        ]])
      end
    end,
  })
  
  -- Register file type detection for Docker files
  vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "Dockerfile", "*.dockerfile", "*.Dockerfile" },
    callback = function()
      vim.bo.filetype = "dockerfile"
    end,
  })
  
  -- Register file type detection for Docker Compose files
  vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "docker-compose*.yml", "docker-compose*.yaml", "compose.yml", "compose.yaml" },
    callback = function()
      vim.bo.filetype = "yaml.docker-compose"
    end,
  })
  
  -- Set up hadolint command for manual linting
  vim.api.nvim_create_user_command("DockerLint", function()
    local filename = vim.fn.expand("%:p")
    vim.cmd("compiler hadolint")
    vim.cmd("silent make! " .. vim.fn.shellescape(filename))
    vim.cmd("copen")
  end, { desc = "Lint Dockerfile with hadolint" })
end

-- Mason tools for Docker
M.mason_tools = {
  lsp = { 'dockerfile-language-server', 'docker-compose-language-service' },
  linters = { 'hadolint' },
}

-- Return both the plugin spec and the language configuration
return {
  -- Plugin specification for plugin manager
  plugin = plugin_spec,
  -- Language configuration for internal use
  config = M
}
