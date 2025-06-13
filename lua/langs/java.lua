local M = {}

-- Java Language Server configuration (handled by nvim-jdtls plugin)
M.lsp = {
  name = "jdtls",
  managed_by_plugin = true,
  plugin = "mfussenegger/nvim-jdtls",
}

-- Java debugging configuration
M.dap = {
  adapter = {
    type = 'server',
    host = '127.0.0.1', 
    port = '${port}',
    executable = {
      command = 'java-debug-adapter',
    },
  },
  configurations = {
    {
      type = 'java',
      request = 'launch',
      name = 'Launch Java Application',
      mainClass = '',
      projectName = '',
      cwd = '${workspaceFolder}',
      args = '',
    },
    {
      type = 'java',
      request = 'attach',
      name = 'Attach to JVM',
      hostName = '127.0.0.1',
      port = '5005',
    },
  },
}

-- Java formatter configuration
M.formatters = { 'google-java-format' }
M.formatter_opts = {
  ['google-java-format'] = {
    prepend_args = {
      '--aosp', -- Android Open Source Project style (4 spaces)
      '--skip-sorting-imports',
      '--skip-removing-unused-imports',
    },
  },
}

-- Java-specific autocmds and settings
M.setup = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'java',
    callback = function()
      vim.opt_local.tabstop = 4
      vim.opt_local.shiftwidth = 4
      vim.opt_local.expandtab = true
      vim.opt_local.textwidth = 120
      
      -- Set up some useful abbreviations
      vim.cmd('iabbrev <buffer> sout System.out.println')
      vim.cmd('iabbrev <buffer> psvm public static void main(String[] args)')
    end,
  })
end

-- Mason tools for Java
M.mason_tools = {
  lsp = { 'jdtls' },
  formatters = { 'google-java-format' },
  debuggers = { 'java-debug-adapter', 'java-test' },
}

-- JDTLS specific configuration
M.jdtls_config = function()
  local jdtls = require('jdtls')
  local mason_registry = require('mason-registry')
  
  -- Get paths to jdtls installation
  local jdtls_pkg = mason_registry.get_package('jdtls')
  local jdtls_path = jdtls_pkg:get_install_path()
  
  -- Determine OS-specific launcher
  local launcher_jar = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')
  
  -- Configuration and workspace paths
  local config_path = jdtls_path .. '/config_linux'
  if vim.fn.has('mac') == 1 then
    config_path = jdtls_path .. '/config_mac'
  elseif vim.fn.has('win32') == 1 then
    config_path = jdtls_path .. '/config_win'
  end
  
  -- Workspace path (project-specific)
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
  local workspace_dir = vim.fn.expand('~/.cache/jdtls/workspace/') .. project_name
  
  -- Enhanced capabilities with nvim-cmp
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  if cmp_nvim_lsp_ok then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end
  
  return {
    cmd = {
      'java',
      '-Declipse.application=org.eclipse.jdt.ls.core.id1',
      '-Dosgi.bundles.defaultStartLevel=4',
      '-Declipse.product=org.eclipse.jdt.ls.core.product',
      '-Dlog.protocol=true',
      '-Dlog.level=ALL',
      '-Xms1g',
      '--add-modules=ALL-SYSTEM',
      '--add-opens',
      'java.base/java.util=ALL-UNNAMED',
      '--add-opens',
      'java.base/java.lang=ALL-UNNAMED',
      '-jar',
      launcher_jar,
      '-configuration',
      config_path,
      '-data',
      workspace_dir,
    },
    root_dir = jdtls.setup.find_root({ '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }),
    capabilities = capabilities,
    settings = {
      java = {
        eclipse = {
          downloadSources = true,
        },
        configuration = {
          updateBuildConfiguration = 'interactive',
          runtimes = {},
        },
        maven = {
          downloadSources = true,
        },
        implementationsCodeLens = {
          enabled = true,
        },
        referencesCodeLens = {
          enabled = true,
        },
        format = {
          enabled = true,
          settings = {
            url = vim.fn.stdpath('config') .. '/lang-servers/intellij-java-google-style.xml',
            profile = 'GoogleStyle',
          },
        },
        signatureHelp = { enabled = true },
        contentProvider = { preferred = 'fernflower' },
        completion = {
          favoriteStaticMembers = {
            'org.hamcrest.MatcherAssert.assertThat',
            'org.hamcrest.Matchers.*',
            'org.hamcrest.CoreMatchers.*',
            'org.junit.jupiter.api.Assertions.*',
            'java.util.Objects.requireNonNull',
            'java.util.Objects.requireNonNullElse',
            'org.mockito.Mockito.*',
          },
          filteredTypes = {
            'com.sun.*',
            'io.micrometer.shaded.*',
            'java.awt.*',
            'jdk.*',
            'sun.*',
          },
        },
        sources = {
          organizeImports = {
            starThreshold = 9999,
            staticStarThreshold = 9999,
          },
        },
        codeGeneration = {
          toString = {
            template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
          },
          useBlocks = true,
        },
      },
    },
  }
end

return M

