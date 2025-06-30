local M = {}
local Menu = require("nui.menu")
local event = require("nui.utils.autocmd").event

local config = {}

-- Setup prompt component
function M.setup(user_config)
  config = user_config
end

-- Show installation prompt for a language
function M.show_install_prompt(language_name, filetype)
  local languages = require("optispec.core.languages")
  local lang_config = languages.get_language_config(language_name)
  
  if not lang_config then
    vim.notify("Language configuration not found: " .. language_name, vim.log.levels.ERROR)
    return
  end
  
  -- Create menu items
  local menu_items = {}
  
  -- Header with language info
  local emoji = M.get_language_emoji(language_name)
  local header = emoji .. " Install " .. language_name:gsub("^%l", string.upper) .. " Development Tools"
  
  -- Add tools info
  if lang_config.mason_tools then
    if lang_config.mason_tools.lsp and #lang_config.mason_tools.lsp > 0 then
      table.insert(menu_items, Menu.item("LSP: " .. table.concat(lang_config.mason_tools.lsp, ", ")))
    end
    if lang_config.mason_tools.formatters and #lang_config.mason_tools.formatters > 0 then
      table.insert(menu_items, Menu.item("Formatter: " .. table.concat(lang_config.mason_tools.formatters, ", ")))
    end
    if lang_config.mason_tools.linters and #lang_config.mason_tools.linters > 0 then
      table.insert(menu_items, Menu.item("Linter: " .. table.concat(lang_config.mason_tools.linters, ", ")))
    end
    if lang_config.mason_tools.dap and #lang_config.mason_tools.dap > 0 then
      table.insert(menu_items, Menu.item("Debugger: " .. table.concat(lang_config.mason_tools.dap, ", ")))
    end
  end
  if lang_config.treesitter and #lang_config.treesitter > 0 then
    table.insert(menu_items, Menu.item("Parser: " .. table.concat(lang_config.treesitter, ", ")))
  end
  
  table.insert(menu_items, Menu.separator("Options", { char = "-", text_align = "center" }))

  -- Menu options
  table.insert(menu_items, Menu.item("✅ Yes - Install"))
  table.insert(menu_items, Menu.item("❌ No - Skip"))
  table.insert(menu_items, Menu.item("🚫 Disable prompts for this language"))
  table.insert(menu_items, Menu.item("🔇 Disable all prompts"))
  table.insert(menu_items, Menu.item("⏭️ Skip this file"))
  
  -- Create the menu
  local menu = Menu({
    position = "50%",
    size = {
      width = 60,
      height = #menu_items + 4,
    },
    border = {
      style = "single",
      text = {
        top = " " .. header .. " ",
        top_align = "center",
      },
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:Normal",
    },
  }, {
    lines = menu_items,
    max_width = 50,
    keymap = {
      focus_next = { "j", "<Down>", "<Tab>" },
      focus_prev = { "k", "<Up>", "<S-Tab>" },
      close = { "<Esc>", "<C-c>", "q" },
      submit = { "<CR>", "<Space>" },
    },
    on_close = function()
      print("Prompt closed.")
    end,
    on_submit = function(item)
      if item.text:match("Yes") then
        require("optispec.core.installer").install_language(language_name)
      elseif item.text:match("Disable prompts for this language") then
        vim.notify("Prompts disabled for " .. language_name, vim.log.levels.INFO)
        -- TODO: Add to disabled languages list
      elseif item.text:match("Disable all prompts") then
        _G.OptiSpec.config.prompt.enabled = false
        vim.notify("All prompts disabled", vim.log.levels.INFO)
      elseif item.text:match("Skip") then
        vim.notify("Skipped " .. language_name .. " installation", vim.log.levels.INFO)
      end
    end,
  })

  -- Mount the menu
  menu:mount()
end

-- Get emoji for language
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

