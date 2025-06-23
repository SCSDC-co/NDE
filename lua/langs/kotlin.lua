-- Kotlin language support configuration
local M = {}

-- Kotlin Language Server configuration
M.lsp = {
  name = "kotlin_language_server",  -- Must match primary provider in nuclear diagnostic system
  cmd = { "kotlin-language-server" },
  filetypes = { "kotlin" },
  root_dir = function(fname)
    local util = require("lspconfig.util")
    return util.root_pattern(
      "settings.gradle", "settings.gradle.kts",
      "build.gradle", "build.gradle.kts",
      "pom.xml",
      ".git"
    )(fname)
  end,
  settings = {
    kotlin = {
      -- Compiler settings
      compiler = {
        jvm = {
          target = "17" -- Target JVM version
        },
      },
      -- Code completion settings
      completion = {
        snippets = {
          enabled = true
        },
      },
      -- Linting settings
      linting = {
        enabled = true,
      },
      -- Code style settings
      codeStyle = {
        indentSize = 4,
      },
      -- Debug adapter settings
      debugAdapter = {
        enabled = true,
        path = nil -- Auto-detect
      },
      -- Formatter settings (ktlint integration)
      formatter = {
        enabled = false, -- We use ktlint via conform.nvim
      },
      -- Spring Boot integration
      spring = {
        enabled = true,
        liveReload = true,
        liveReloadUrl = "http://localhost:8080/",
      },
      -- Telemetry settings
      telemetry = {
        enabled = false
      },
    }
  },
  capabilities = nil, -- Will be set by main LSP config
  on_attach = function(client, bufnr)
    -- Disable LSP formatting (handled by ktlint)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    -- Kotlin-specific keymaps
    local opts = { noremap = true, silent = true, buffer = bufnr }
    
    -- Run with Gradle
    vim.keymap.set('n', '<leader>kr', function()
      vim.cmd('terminal ./gradlew run')
      vim.cmd('startinsert')
    end, { desc = 'Gradle run', buffer = bufnr })
    
    -- Build with Gradle
    vim.keymap.set('n', '<leader>kb', function()
      vim.cmd('terminal ./gradlew build')
      vim.cmd('startinsert')
    end, { desc = 'Gradle build', buffer = bufnr })
    
    -- Test with Gradle
    vim.keymap.set('n', '<leader>kt', function()
      vim.cmd('terminal ./gradlew test')
      vim.cmd('startinsert')
    end, { desc = 'Gradle test', buffer = bufnr })
    
    -- Run with Maven
    vim.keymap.set('n', '<leader>kmr', function()
      vim.cmd('terminal mvn exec:java')
      vim.cmd('startinsert')
    end, { desc = 'Maven run', buffer = bufnr })
    
    -- Build with Maven
    vim.keymap.set('n', '<leader>kmb', function()
      vim.cmd('terminal mvn package')
      vim.cmd('startinsert')
    end, { desc = 'Maven build', buffer = bufnr })
    
    -- Test with Maven
    vim.keymap.set('n', '<leader>kmt', function()
      vim.cmd('terminal mvn test')
      vim.cmd('startinsert')
    end, { desc = 'Maven test', buffer = bufnr })
    
    -- Spring Boot - Start application
    vim.keymap.set('n', '<leader>ks', function()
      if vim.fn.filereadable("./gradlew") == 1 then
        vim.cmd('terminal ./gradlew bootRun')
      else
        vim.cmd('terminal mvn spring-boot:run')
      end
      vim.cmd('startinsert')
    end, { desc = 'Spring Boot run', buffer = bufnr })
    
    -- Format with ktlint
    vim.keymap.set('n', '<leader>kf', function()
      vim.lsp.buf.format({ async = true })
    end, { desc = 'Format Kotlin file', buffer = bufnr })
    
    -- Create new Kotlin class
    vim.keymap.set('n', '<leader>kc', function()
      local class_name = vim.fn.input('Class name: ')
      if class_name and class_name ~= '' then
        local package_stmt = vim.fn.getline(1)
        local package_name = ""
        if string.match(package_stmt, "^package%s+([%w%.]+)") then
          package_name = string.match(package_stmt, "^package%s+([%w%.]+)")
        end
        
        local content = ""
        if package_name ~= "" then
          content = content .. "package " .. package_name .. "\n\n"
        end
        
        content = content .. "class " .. class_name .. " {\n    \n}"
        
        local filename = class_name .. ".kt"
        local file = io.open(filename, "w")
        if file then
          file:write(content)
          file:close()
          vim.cmd("edit " .. filename)
          -- Position cursor inside class body
          vim.cmd("normal! G2k$")
        else
          vim.notify("Failed to create class file", vim.log.levels.ERROR)
        end
      end
    end, { desc = 'New Kotlin class', buffer = bufnr })
  end,
}

-- Kotlin formatter configuration
M.formatters = { 'ktlint' }
M.formatter_opts = {
  ktlint = {},  -- Using configuration from ktlint.lua
}

-- Kotlin-specific autocmds and settings
M.setup = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'kotlin' },
    callback = function()
      -- Kotlin indentation settings
      vim.opt_local.tabstop = 4
      vim.opt_local.shiftwidth = 4
      vim.opt_local.expandtab = true
      vim.opt_local.commentstring = "// %s"
      vim.opt_local.smartindent = true
      
      -- Enhanced syntax highlighting
      vim.cmd([[
        syntax match kotlinFunction "\<\([a-z][a-zA-Z0-9_]*\)\s*\("he=e-1
        highlight link kotlinFunction Function
        
        syntax match kotlinType "\<\([A-Z][a-zA-Z0-9_]*\)\>"
        highlight link kotlinType Type
        
        syntax match kotlinAnnotation "@\<\([A-Za-z][a-zA-Z0-9_]*\)\>"
        highlight link kotlinAnnotation PreProc
      ]])
      
      -- Set folding for Kotlin files
      vim.opt_local.foldmethod = "indent"
      vim.opt_local.foldenable = false -- Start with folds open
      
      -- Completion settings
      vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
    end,
  })
  
  -- Detect Kotlin files
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.kt', '*.kts' },
    callback = function()
      vim.bo.filetype = 'kotlin'
    end,
  })
  
  -- Add Kotlin icon for file explorer
  local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
  if devicons_ok then
    devicons.set_icon({
      kt = {
        icon = "",
        color = "#7F52FF",
        name = "Kotlin"
      },
      kts = {
        icon = "",
        color = "#7F52FF",
        name = "KotlinScript"
      }
    })
  end
  
  -- Lazy load Kotlin-related plugins if available
  local lazy_loader = require("utils.lazy_loader")
  lazy_loader.on_filetype({"kotlin"}, function()
    -- Load Kotlin treesitter if available
    pcall(function() 
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "kotlin" },
      })
    end)
  end)
  
  -- Add Kotlin commands
  vim.api.nvim_create_user_command("KotlinNewProject", function(opts)
    local project_name = opts.args
    if project_name and project_name ~= "" then
      local cmd = "mkdir -p " .. project_name .. " && cd " .. project_name
      
      -- Check if we should create a Gradle or Maven project
      local project_type = vim.fn.input("Project type (gradle/maven): ")
      if project_type:lower() == "gradle" then
        cmd = cmd .. " && gradle init --type kotlin-application --dsl kotlin --project-name " .. project_name
      elseif project_type:lower() == "maven" then
        cmd = cmd .. " && mvn archetype:generate -DgroupId=com.example -DartifactId=" .. 
              project_name .. " -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false"
      else
        vim.notify("Unsupported project type. Use 'gradle' or 'maven'.", vim.log.levels.ERROR)
        return
      end
      
      vim.cmd('terminal ' .. cmd)
      vim.cmd('startinsert')
    else
      vim.notify("Please provide a project name", vim.log.levels.ERROR)
    end
  end, { nargs = 1, desc = "Create a new Kotlin project" })
  
  vim.api.nvim_create_user_command("KotlinAddDependency", function(opts)
    local dep = opts.args
    if dep and dep ~= "" then
      -- Check if we're in a Gradle or Maven project
      if vim.fn.filereadable("build.gradle") == 1 or vim.fn.filereadable("build.gradle.kts") == 1 then
        -- For Gradle
        vim.cmd('edit build.gradle.kts')
        vim.cmd('/dependencies')
        vim.cmd('normal! o    implementation("' .. dep .. '")')
      elseif vim.fn.filereadable("pom.xml") == 1 then
        -- For Maven
        vim.cmd('edit pom.xml')
        vim.cmd('/dependencies')
        vim.cmd('normal! o    <dependency>\n        <groupId>' .. 
                dep:match("([^:]+)") .. '</groupId>\n        <artifactId>' .. 
                dep:match(":([^:]+)") .. '</artifactId>\n        <version>' .. 
                dep:match(":([^:]+)$") .. '</version>\n    </dependency>')
      else
        vim.notify("No build.gradle or pom.xml found", vim.log.levels.ERROR)
      end
    else
      vim.notify("Please provide a dependency in the format 'group:artifact:version'", vim.log.levels.ERROR)
    end
  end, { nargs = 1, desc = "Add dependency to Kotlin project" })
end

-- Mason tools for Kotlin
M.mason_tools = {
  lsp = { 'kotlin_language_server' },
  formatters = { 'ktlint' },
  debuggers = { 'java-debug-adapter' }, -- Uses Java debug for Kotlin
}

return M
