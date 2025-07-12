-- 🚀 Enable Neovim's built-in bytecode cache for faster startup
if vim.loader then
  vim.loader.enable()
end

-- ⏱️ Initialize startup timer for dashboard display
vim.g.startup_timer = vim.fn.reltime()

-- 🔧 Cross-platform home directory detection
local home = vim.fn.expand("~")
local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1

-- 🐍 Python virtual environment setup (cross-platform)
local venv_path = is_windows and "/AppData/Local/nvim_pytools_venv/Scripts/python.exe" or "/.local/share/nvim_pytools_venv/bin/python"
local venv_py = home .. venv_path
if vim.fn.executable(venv_py) == 1 then
  vim.g.python3_host_prog = venv_py
else
  vim.notify("⚠️ Python venv not found: " .. venv_py, vim.log.levels.WARN)
end

-- 🪨 LuaRocks path setup (cross-platform)
local version = "5.4"
if is_windows then
  -- Windows LuaRocks paths
  local luarocks_path = home .. "/AppData/Roaming/luarocks"
  package.path  = luarocks_path .. "/share/lua/" .. version .. "/?.lua;" .. package.path
  package.cpath = luarocks_path .. "/lib/lua/" .. version .. "/?.dll;" .. package.cpath
else
  -- Unix/Linux LuaRocks paths
  package.path  = home .. "/.luarocks/share/lua/" .. version .. "/?.lua;" .. package.path
  package.cpath = home .. "/.luarocks/lib/lua/" .. version .. "/?.so;" .. package.cpath
end

require("launch")
