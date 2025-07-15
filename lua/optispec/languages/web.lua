local M = {}

-- Web Development Language Configurations
function M.setup()
  -- JavaScript
  require("optispec.core.languages").register_language("javascript", {
    filetypes = { "javascript", "javascriptreact" },
    mason_tools = {
      lsp = { "typescript-language-server" },
      formatters = { "prettierd" },
      dap = { "node-debug2-adapter" },
    },
    lsp = {
      name = "ts_ls",
      settings = {},
    },
    treesitter = { "javascript", "tsx" },
  })
  
  -- TypeScript
  require("optispec.core.languages").register_language("typescript", {
    filetypes = { "typescript", "typescriptreact" },
    mason_tools = {
      lsp = { "typescript-language-server" },
      formatters = { "prettierd" },
      dap = { "node-debug2-adapter" },
    },
    lsp = {
      name = "ts_ls",
      settings = {},
    },
    treesitter = { "typescript", "tsx" },
  })

  -- Vue
  require("optispec.core.languages").register_language("vue", {
    filetypes = { "vue" },
    mason_tools = {
      lsp = { "vue-language-server" },
      formatters = { "prettierd" },
    },
    lsp = {
      name = "vue_ls",
      settings = {},
    },
    treesitter = { "vue" },
  })

  -- Angular
  require("optispec.core.languages").register_language("angular", {
    filetypes = { "typescript", "html", "scss" },
    mason_tools = {
      lsp = { "angular-language-server" },
      formatters = { "prettierd" },
    },
    lsp = {
      name = "angularls",
      settings = {},
    },
    treesitter = { "html", "typescript", "scss" },
  })

  -- Svelte
  require("optispec.core.languages").register_language("svelte", {
    filetypes = { "svelte" },
    mason_tools = {
      lsp = { "svelte-language-server" },
      formatters = { "prettierd" },
    },
    lsp = {
      name = "svelte",
      settings = {},
    },
    treesitter = { "svelte" },
  })

  -- Tailwind CSS
  require("optispec.core.languages").register_language("tailwindcss", {
    filetypes = { 
      "typescript", "javascript", "html", "css", "scss", "sass", "less",
      "svelte", "vue", "astro", "javascriptreact", "typescriptreact",
      -- ASP.NET and related
      "razor", "cshtml", "vbhtml", "aspx", "ascx", "master",
      -- PHP frameworks
      "php", "blade", "twig",
      -- Other templating engines
      "ejs", "erb", "handlebars", "hbs", "mustache", "liquid",
      -- JSX/TSX variants
      "jsx", "tsx"
    },
    mason_tools = {
      lsp = { "tailwindcss-language-server" },
    },
    lsp = {
      name = "tailwindcss-language-server",
      settings = {
        -- Enable Tailwind CSS IntelliSense for more file types
        includeLanguages = {
          razor = "html",
          cshtml = "html",
          vbhtml = "html",
          aspx = "html",
          ascx = "html",
          master = "html",
          blade = "html",
          twig = "html",
          ejs = "html",
          erb = "html",
          handlebars = "html",
          hbs = "html",
          mustache = "html",
          liquid = "html",
        },
        -- Experimental features
        experimental = {
          classRegex = {
            -- ASP.NET Razor syntax
            "class=\"([^\"]*)\"",
            "class='([^']*)'",
            "@class=\"([^\"]*)\"",
            "@class='([^']*)'",
            -- React className
            "className=\"([^\"]*)\"",
            "className='([^']*)'",
            -- Vue class binding
            ":class=\"([^\"]*)\"",
            ":class='([^']*)'",
            "v-bind:class=\"([^\"]*)\"",
            "v-bind:class='([^']*)'",
          },
        },
      },
    },
    treesitter = {},
  })

  -- Emmet (HTML/CSS abbreviation expansion)
  require("optispec.core.languages").register_language("emmet", {
    filetypes = { 
      "html", "xhtml", "xml", "css", "scss", "sass", "less", "stylus",
      "javascriptreact", "typescriptreact", "vue", "svelte", "astro",
      -- ASP.NET and related
      "razor", "cshtml", "vbhtml", "aspx", "ascx", "master",
      -- PHP frameworks
      "php", "blade", "twig",
      -- Other templating engines
      "ejs", "erb", "handlebars", "hbs", "mustache", "liquid",
      -- JSX/TSX variants
      "jsx", "tsx"
    },
    mason_tools = {
      lsp = { "emmet-language-server" },
    },
    lsp = {
      name = "emmet_language_server",
      settings = {
        -- Enable emmet for more filetypes
        filetypes = {
          "html", "xhtml", "xml", "css", "scss", "sass", "less", "stylus",
          "javascriptreact", "typescriptreact", "vue", "svelte", "astro",
          "razor", "cshtml", "vbhtml", "aspx", "ascx", "master",
          "php", "blade", "twig",
          "ejs", "erb", "handlebars", "hbs", "mustache", "liquid",
          "jsx", "tsx"
        },
        -- Show expanded abbreviations in completion
        showExpandedAbbreviation = "always",
        -- Show abbreviations as snippets
        showAbbreviationSuggestions = true,
        -- Include languages that have snippets disabled
        includeLanguages = {},
        -- Variables to be used in snippets
        variables = {},
        -- Exclude languages from emmet abbreviations
        excludeLanguages = {},
        -- Extend language support
        extensionsPath = {},
        -- Preferences for emmet
        preferences = {},
        -- Show suggestions even when prefix doesn't match
        showSuggestionsAsSnippets = false,
        -- Syntaxes for which to show emmet suggestions
        syntaxProfiles = {},
      },
    },
    treesitter = {},
  })

  -- Astro
  require("optispec.core.languages").register_language("astro", {
    filetypes = { "astro" },
    mason_tools = {
      lsp = { "astro-language-server" },
      formatters = { "prettierd" },
    },
    lsp = {
      name = "astro-language-server",
      settings = {},
    },
    treesitter = { "astro" },
  })
end

return M
