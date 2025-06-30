local M = {}
local Popup = require("nui.popup")

local config = {}

-- Setup status component
function M.setup(user_config)
  config = user_config
end

-- Show OptiSpec status
function M.show()
  local installer = require("optispec.core.installer")
  local status = installer.get_status()
  
  -- Calculate dynamic height based on content
  local base_height = 15 -- Base height for header, stats, commands
  local dynamic_height = base_height + math.max(#status.installed, 0) + 5 -- Extra space for available languages
  local max_height = math.min(dynamic_height, 35) -- Cap at 35 lines
  
  -- Create the popup
  local popup = Popup({
    enter = true,
    focusable = true,
    border = {
      style = "rounded",
      text = {
        top = " 📊 OptiSpec Status Dashboard ",
        top_align = "center",
      },
    },
    position = "50%",
    size = {
      width = 60,
      height = max_height,
    },
    buf_options = {
      modifiable = false,
      readonly = true,
    },
  })
  
  -- Create content
  local content = {}
  
  -- Header
  table.insert(content, "")
  table.insert(content, "  🚀 OptiSpec Language Management")
  table.insert(content, "")
  
  -- Statistics
  table.insert(content, "  📈 Statistics:")
  table.insert(content, "  ├── Total Languages: " .. status.total)
  table.insert(content, "  ├── Installed: " .. #status.installed)
  table.insert(content, "  └── Available: " .. #status.available)
  table.insert(content, "")
  
  -- Installed languages (show ALL)
  if #status.installed > 0 then
    table.insert(content, "  ✅ Installed Languages:")
    for i, lang in ipairs(status.installed) do
      local emoji = M.get_language_emoji(lang)
      local prefix = i == #status.installed and "  └──" or "  ├──"
      table.insert(content, prefix .. " " .. emoji .. " " .. lang:gsub("^%l", string.upper))
    end
    table.insert(content, "")
  else
    table.insert(content, "  ❌ No languages installed yet")
    table.insert(content, "  💡 Use :NDE optispec browse to install languages")
    table.insert(content, "")
  end
  
  -- Available languages (show first 5)
  if #status.available > 0 then
    table.insert(content, "  📦 Available Languages:")
    local count = math.min(5, #status.available)
    for i = 1, count do
      local lang = status.available[i]
      local emoji = M.get_language_emoji(lang)
      local prefix = i == count and "  └──" or "  ├──"
      table.insert(content, prefix .. " " .. emoji .. " " .. lang:gsub("^%l", string.upper))
    end
    if #status.available > 5 then
      table.insert(content, "  ... and " .. (#status.available - 5) .. " more available")
    end
    table.insert(content, "")
  end
  
  -- Commands
  table.insert(content, "  ⌨️  Commands:")
  table.insert(content, "  ├── :NDE optispec browse - Browse all languages")
  table.insert(content, "  ├── :NDE optispec install <lang> - Install language")
  table.insert(content, "  ├── :NDE optispec remove <lang> - Remove language")
  table.insert(content, "  └── :NDE optispec update - Update all tools")
  table.insert(content, "")
  table.insert(content, "    Press 'q' or <Esc> to close")
  
  -- Set content
  vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, content)
  
  -- Keymaps
  popup:map("n", "q", function()
    popup:unmount()
  end, { noremap = true })
  popup:map("n", "<Esc>", function()
    popup:unmount()
  end, { noremap = true })
  
  -- Mount the popup
  popup:mount()
end

-- Get emoji for language (reuse from other components)
function M.get_language_emoji(language)
  local emojis = {
    python = "🐍",
    javascript = "🟨",
    typescript = "⚡",
    rust = "🦀",
    go = "🐹",
    java = "☕",
    lua = "🌙",
    ruby = "💎",
    php = "🐘",
    shell = "🐚",
    docker = "🐳",
    git = "🔧",
    markdown = "📝",
    json = "📄",
    yaml = "⚙️",
    html = "🌐",
    css = "🎨",
    vue = "💚",
    react = "⚛️",
    angular = "🅰️",
    svelte = "🧡",
    astro = "🚀",
    haskell = "🔍",
    ocaml = "🐪",
    clojure = "🔥",
    erlang = "📡",
    elixir = "💧",
    elm = "🌳",
    gleam = "✨",
    lean = "📐",
    zig = "⚡",
    nix = "❄️",
    terraform = "🏗️",
    ansible = "📦",
    helm = "🚢",
    sql = "🗃️",
    prisma = "🔷",
    r = "📊",
    tex = "📚",
    clangs = "⚙️",
    kotlin = "🎯",
    scala = "🔴",
    csharp = "💙",
    toml = "⚙️",
    cmake = "🔨",
    nushell = "🐚",
    thrift = "📡",
  }
  
  return emojis[language] or "📝"
end

return M
