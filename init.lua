local home = os.getenv("HOME")
local venv_py = home .. "/.local/share/nvim_pytools_venv/bin/python"
if vim.fn.executable(venv_py) == 1 then
  vim.g.python3_host_prog = venv_py
else
  vim.notify("⚠️ Python venv not found: " .. venv_py, vim.log.levels.WARN)
end

local version = "5.4"
package.path  = home .. "/.luarocks/share/lua/"..version.."/?.lua;"  .. package.path
package.cpath = home .. "/.luarocks/lib/lua/"..version.."/?.so;"    .. package.cpath

require("launch")
