vim.env.PATH = vim.env.PATH .. ":" .. os.getenv("HOME") .. "/.luarocks/bin"
require "opts"

require "lazynvim.lazy"
require "GUI.theme"
require "keymaps"

-- 🎉 Initialize NDE beginner tips system
require("nde.tips").setup({
  enabled = true,    -- Show tips by default
  interval = 45000,  -- 45 seconds between tips
})

-- 🔧 Initialize OptiSpec language environment
require("optispec").setup({
  languages = {},
  
  prompt = {
    enabled = true,
    auto_install = false,
  },
  
  -- Tool integration
  tools = {
    mason = { auto_update = true },
    lsp = { auto_attach = true },
    diagnostics = { merge_sources = true },
  },
})
