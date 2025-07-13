-- NDE Health Check Module
-- Comprehensive version and dependency checking for optimal NDE experience

local M = {}

-- Health check function compatibility (for older/newer Neovim versions)
local start = vim.health.start or vim.health.report_start
local ok = vim.health.ok or vim.health.report_ok
local warn = vim.health.warn or vim.health.report_warn
local error = vim.health.error or vim.health.report_error
local info = vim.health.info or vim.health.report_info

-- Helper function to check if a command exists
local function executable(cmd)
  return vim.fn.executable(cmd) == 1
end

-- Helper function to get version info
local function get_version(cmd, args)
  args = args or {"--version"}
  local result = vim.fn.system(table.concat({cmd, unpack(args)}, " "))
  return vim.split(result, "\n")[1] or "Unknown"
end

-- Check Neovim version requirements
local function check_neovim()
  start("🚀 Neovim Version Requirements")
  
  local nvim_version = vim.version()
  local version_str = string.format("%d.%d.%d", nvim_version.major, nvim_version.minor, nvim_version.patch)
  
  if vim.fn.has("nvim-0.10.0") == 1 then
    ok(string.format("✅ Using Neovim %s (Excellent! Latest features available)", version_str))
  elseif vim.fn.has("nvim-0.9.0") == 1 then
    ok(string.format("✅ Using Neovim %s (Good! Core features supported)", version_str))
    warn("⚡ Consider upgrading to Neovim >= 0.10.0 for the ultimate NDE experience")
  else
    error(string.format("❌ Using Neovim %s - UPGRADE REQUIRED!", version_str))
    error("🔥 NDE requires Neovim >= 0.9.0 for proper functionality")
  end
end

-- Check essential development tools
local function check_essential_tools()
  start("🛠️  Essential Development Tools")
  
  local essential_tools = {
    "git", "curl", "wget", "unzip", "gcc", "make"
  }
  
  for _, tool in ipairs(essential_tools) do
    if executable(tool) then
      local version = get_version(tool)
      ok(string.format("✅ `%s` is installed: %s", tool, version))
    else
      error(string.format("❌ `%s` is missing - Required for core functionality!", tool))
    end
  end
end

-- Check modern CLI tools (recommended but not required)
local function check_modern_tools()
  start("⚡ Modern CLI Tools (Recommended)")
  
  local modern_tools = {
    {"rg", "ripgrep"}, -- Telescope search
    {"fd", "fdfind"}, -- File finding
    {"fzf", nil}, -- Fuzzy finder
    {"bat", nil}, -- Better cat
    {"lazygit", nil}, -- Git TUI
    {"delta", nil}, -- Git diff viewer
    {"exa", "ls"}, -- Better ls
    {"zoxide", nil}, -- Smart cd
  }
  
  for _, tool_info in ipairs(modern_tools) do
    local cmd = tool_info[1]
    local alt_name = tool_info[2]
    
    if executable(cmd) then
      local version = get_version(cmd)
      ok(string.format("✅ `%s` is installed: %s", cmd, version))
    elseif alt_name and executable(alt_name) then
      local version = get_version(alt_name)
      ok(string.format("✅ `%s` (as `%s`) is installed: %s", cmd, alt_name, version))
    else
      warn(string.format("⚠️  `%s` is not installed - Recommended for enhanced experience", cmd))
    end
  end
end


-- Check LSP servers (via Mason)
local function check_lsp_servers()
  start("🧠 LSP Server Environment")
  
  local mason_ok, mason_registry = pcall(require, "mason-registry")
  if not mason_ok then
    warn("⚠️  Mason not available - LSP server checking skipped")
    return
  end
  
  local installed_packages = mason_registry.get_installed_packages()
  if #installed_packages > 0 then
    ok(string.format("✅ Mason has %d packages installed", #installed_packages))
    
    local lsp_count = 0
    local formatter_count = 0
    local linter_count = 0
    
    for _, pkg in ipairs(installed_packages) do
      local spec = pkg.spec
      if spec.categories then
        for _, category in ipairs(spec.categories) do
          if category == "LSP" then
            lsp_count = lsp_count + 1
          elseif category == "Formatter" then
            formatter_count = formatter_count + 1
          elseif category == "Linter" then
            linter_count = linter_count + 1
          end
        end
      end
    end
    
    if lsp_count > 0 then
      ok(string.format("✅ %d LSP servers installed", lsp_count))
    end
    if formatter_count > 0 then
      ok(string.format("✅ %d formatters installed", formatter_count))
    end
    if linter_count > 0 then
      ok(string.format("✅ %d linters installed", linter_count))
    end
  else
    warn("⚠️  No Mason packages installed yet - run :OptiSpec browse to install language tools")
  end
end

-- Check NDE-specific components
local function check_nde_components()
  start("🎯 NDE Core Components")
  
  -- Check OptiSpec
  local optispec_ok, optispec = pcall(require, "optispec")
  if optispec_ok then
    ok("✅ OptiSpec language management system loaded")
  else
    error("❌ OptiSpec failed to load - Core NDE functionality impacted!")
  end
  
  -- Check tips system
  local tips_ok, tips = pcall(require, "nde.tips")
  if tips_ok then
    ok("✅ NDE Tips learning system loaded")
  else
    warn("⚠️  NDE Tips system failed to load")
  end
  
  -- Check command suite
  local cmd_ok, cmd_suite = pcall(require, "nde.command-suite")
  if cmd_ok then
    ok("✅ NDE Command Suite loaded")
  else
    warn("⚠️  NDE Command Suite failed to load")
  end
  
  -- Check local plugins
  local minty_ok = pcall(require, "local_plugins.minty")
  if minty_ok then
    ok("✅ Local minty plugin enhancements loaded")
  else
    warn("⚠️  Local minty enhancements failed to load")
  end
end

-- Check plugin ecosystem health
local function check_plugin_health()
  start("🔌 Plugin Ecosystem Health")
  
  -- Check Lazy.nvim
  local lazy_ok, lazy = pcall(require, "lazy")
  if lazy_ok then
    local stats = lazy.stats()
    ok(string.format("✅ Lazy.nvim managing %d plugins", stats.count))
    
    if stats.loaded > 0 then
      ok(string.format("✅ %d plugins currently loaded", stats.loaded))
    end
    
    if stats.times and stats.times.startuptime then
      local startup_ms = math.floor(stats.times.startuptime)
      if startup_ms < 50 then
        ok(string.format("🚀 Excellent startup time: %dms", startup_ms))
      elseif startup_ms < 100 then
        ok(string.format("⚡ Good startup time: %dms", startup_ms))
      else
        warn(string.format("🐌 Slow startup time: %dms - Consider optimizing", startup_ms))
      end
    end
  else
    error("❌ Lazy.nvim not available - Plugin management broken!")
  end
  
  -- Check core plugins
  local core_plugins = {
    "nvim-treesitter", "nvim-lspconfig", "nvim-cmp", "telescope.nvim"
  }
  
  for _, plugin in ipairs(core_plugins) do
    local plugin_ok = pcall(require, plugin)
    if plugin_ok then
      ok(string.format("✅ %s loaded successfully", plugin))
    else
      warn(string.format("⚠️  %s failed to load", plugin))
    end
  end
end

-- Performance and environment check
local function check_performance()
  start("📈 Performance Environment")
  
  -- Check Lua version
  ok(string.format("✅ Lua version: %s", _VERSION))
  
  -- Check if running in terminal with good capabilities
  if vim.env.TERM then
    ok(string.format("✅ Terminal: %s", vim.env.TERM))
  end
  
  if vim.env.COLORTERM then
    ok(string.format("✅ Color support: %s", vim.env.COLORTERM))
  end
  
  -- Check OS
  local os_name = vim.loop.os_uname().sysname
  ok(string.format("✅ Operating System: %s", os_name))
  
  -- Memory usage
  local mem_usage = vim.fn.luaeval("collectgarbage('count')")
  if mem_usage < 50000 then
    ok(string.format("✅ Memory usage: %.1f MB (Excellent)", mem_usage / 1024))
  elseif mem_usage < 100000 then
    ok(string.format("⚠️  Memory usage: %.1f MB (Good)", mem_usage / 1024))
  else
    warn(string.format("🐌 Memory usage: %.1f MB (High - consider restart)", mem_usage / 1024))
  end
end

-- Main health check function
function M.check()
  info("🚀 NDE (Neovim Development Environment) Health Check")
  info("=" .. string.rep("=", 50))
  
  check_neovim()
  check_essential_tools()
  check_modern_tools()
  check_lsp_servers()
  check_nde_components()
  check_plugin_health()
  check_performance()
  
  info("=" .. string.rep("=", 50))
  info("🎉 Health check complete! For issues, check: https://github.com/SCSDC-co/NDE")
end

-- Expose individual check functions for targeted diagnostics
M.check_neovim = check_neovim
M.check_essential_tools = check_essential_tools
M.check_modern_tools = check_modern_tools
M.check_lsp_servers = check_lsp_servers
M.check_nde_components = check_nde_components
M.check_plugin_health = check_plugin_health
M.check_performance = check_performance

return M
