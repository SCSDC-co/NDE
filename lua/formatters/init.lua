local M = {}

-- Available formatters
local formatters = {
  -- Existing formatters
  "black",
  "isort",
  "rustfmt",
  "clang-format",
  "prettierd",
  "stylua",
  "gofmt",
  "goimports",
  "google-java-format",
  "shfmt",
  "zig_fmt",
  "php-cs-fixer",
  "phpcbf",
  
  -- New formatters
  "fourmolu",     -- Haskell
  "ktlint",       -- Kotlin
  "alejandra",    -- Nix
  "ocamlformat",  -- OCaml
  "csharpier",    -- C#
  "prisma-fmt",   -- Prisma
  "styler",       -- R
  "rubocop",      -- Ruby
  "scalafmt",     -- Scala
  "sql-formatter", -- SQL
  "terraform-fmt", -- Terraform
  "latexindent",  -- LaTeX
  "taplo",        -- TOML
}

-- Cache for loaded configurations
local _cached_formatter_configs = nil
local _formatter_setup_done = false

-- Load all formatter configurations
local function load_formatters()
  if _cached_formatter_configs then
    return _cached_formatter_configs
  end
  
  local configs = {}
  for _, formatter in ipairs(formatters) do
    local success, config = pcall(require, 'formatters.' .. formatter)
    if success then
      configs[formatter] = config
    else
      vim.notify("Failed to load formatter: " .. formatter, vim.log.levels.WARN)
    end
  end
  
  _cached_formatter_configs = configs
  return configs
end

-- Build formatters_by_ft table for conform.nvim
M.get_formatters_by_ft = function()
  local formatter_configs = load_formatters()
  local formatters_by_ft = {}
  
  -- Method 1: From formatter configs (formatter -> languages)
  for formatter_name, config in pairs(formatter_configs) do
    if config.languages then
      for _, lang in ipairs(config.languages) do
        if not formatters_by_ft[lang] then
          formatters_by_ft[lang] = {}
        end
        table.insert(formatters_by_ft[lang], formatter_name)
      end
    end
  end
  
  -- Method 2: From language configs (language -> formatters)
  local success, langs = pcall(require, 'langs')
  if success then
    local lang_configs = langs.setup()
    -- Load individual language configs to get their formatter preferences
    local languages = {
      -- Core languages
      "python", "rust", "c_cpp", "javascript_typescript", "lua",
      "go", "java", "zig", "php", "json", "yaml", "markdown",
      
      -- Web/Frontend
      "angular", "astro", "svelte", "vue",
      
      -- System/Infrastructure
      "ansible", "docker", "terraform", "nix",
      
      -- Infrastructure/Config
      "helm", "prisma", "toml",
      
      -- Functional languages
      "clojure", "elm", "erlang", "gleam", "haskell", "ocaml",
      
      -- JVM languages
      "kotlin", "scala",
      
      -- Other languages
      "cmake", "csharp", "elixir", "lean", "nushell",
      "r", "rego", "ruby", "sql", "tex", "thrift",
      
      -- Tools/Utils
      "git", "tailwind", "shell"
    }
    
    for _, lang_name in ipairs(languages) do
      local lang_success, lang_config = pcall(require, 'langs.' .. lang_name)
      if lang_success and lang_config.formatters then
        -- Map language names to file types
        local lang_to_ft = {
          -- Existing mappings
          python = "python",
          rust = "rust",
          c_cpp = { "c", "cpp", "h", "hpp" },
          javascript_typescript = { "javascript", "typescript", "javascriptreact", "typescriptreact", "js", "ts", "jsx", "tsx" },
          lua = "lua",
          go = "go",
          java = "java",
          zig = "zig",
          php = "php",
          shell = { "sh", "bash", "zsh" },
          
          -- New mappings
          haskell = { "haskell", "hs", "lhs" },
          kotlin = { "kotlin", "kt", "kts" },
          nix = "nix",
          ocaml = { "ocaml", "ml", "mli" },
          csharp = { "cs", "csharp" },
          prisma = "prisma",
          r = { "r", "rmd" },
          ruby = { "ruby", "rb" },
          scala = "scala",
          sql = "sql",
          tex = { "tex", "cls", "sty" },
          toml = "toml",
          
          -- Prettierd handled
          json = { "json", "jsonc", "json5" },
          yaml = { "yaml", "yml" },
          markdown = { "markdown", "md", "mdx" },
          svelte = "svelte",
          vue = "vue",
          
          -- Other languages
          gleam = "gleam",
          helm = "helm",
          lean = "lean",
          nushell = { "nu", "nushell" },
          rego = "rego",
          thrift = "thrift"
        }
        
        local filetypes = lang_to_ft[lang_name]
        if filetypes then
          if type(filetypes) == "string" then
            filetypes = { filetypes }
          end
          
          for _, ft in ipairs(filetypes) do
            if not formatters_by_ft[ft] then
              formatters_by_ft[ft] = {}
            end
            -- Add formatters from language config, avoid duplicates
            for _, formatter_name in ipairs(lang_config.formatters) do
              if not vim.tbl_contains(formatters_by_ft[ft], formatter_name) then
                table.insert(formatters_by_ft[ft], formatter_name)
              end
            end
          end
        end
      end
    end
  end
  
  return formatters_by_ft
end

-- Build formatter options for conform.nvim
M.get_formatter_configs = function()
  local formatter_configs = load_formatters()
  local configs = {}
  
  for formatter_name, config in pairs(formatter_configs) do
    if config.setup then
      configs[formatter_name] = config.setup()
    end
  end
  
  return configs
end

-- Get all mason packages needed for formatters
M.get_mason_packages = function()
  local formatter_configs = load_formatters()
  local packages = {}
  
  for _, config in pairs(formatter_configs) do
    if config.mason_package then
      table.insert(packages, config.mason_package)
    end
  end
  
  -- Remove duplicates
  local unique_packages = {}
  local seen = {}
  for _, package in ipairs(packages) do
    if not seen[package] then
      seen[package] = true
      table.insert(unique_packages, package)
    end
  end
  
  return unique_packages
end

-- Get formatter info for a specific language
M.get_formatter_for_language = function(language)
  local formatter_configs = load_formatters()
  
  for formatter_name, config in pairs(formatter_configs) do
    if config.languages and vim.tbl_contains(config.languages, language) then
      return {
        name = formatter_name,
        config = config,
      }
    end
  end
  
  return nil
end

-- Setup all formatters
M.setup = function()
  local formatter_configs = load_formatters()
  
  if not _formatter_setup_done then
    _formatter_setup_done = true
  end
  
  return {
    formatters_by_ft = M.get_formatters_by_ft(),
    formatters = M.get_formatter_configs(),
  }
end

return M

