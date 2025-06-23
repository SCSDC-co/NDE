-- NDE Command Suite
-- Centralized command system for all NDE functionality

local M = {}

-- Import modules
local tips = require('nde.tips')
local dynamic_loader = require('performance.dynamic_loader')

-- Snippets functionality
local function list_snippets()
  -- Check if LuaSnip is available
  local ok, ls = pcall(require, 'luasnip')
  if not ok then
    vim.notify(
      '❌ LuaSnip not available\n\n' ..
      'Install LuaSnip to use snippets functionality',
      vim.log.levels.ERROR,
      { title = '🚀 NDE Snippets' }
    )
    return
  end
  
  local ft = vim.bo.filetype
  if ft == '' then
    vim.notify(
      '⚠️  No filetype detected\n\n' ..
      'Open a file with a recognized filetype to see available snippets',
      vim.log.levels.WARN,
      { title = '🚀 NDE Snippets' }
    )
    return
  end
  
  local snippets = ls.get_snippets(ft)
  if not snippets or vim.tbl_isempty(snippets) then
    vim.notify(
      '📝 No snippets available for filetype: ' .. ft .. '\n\n' ..
      'Supported languages include: Python, JavaScript/TypeScript, Rust, Go, C/C++, Lua, HTML, SQL',
      vim.log.levels.INFO,
      { title = '🚀 NDE Snippets' }
    )
    return
  end
  
  local snippet_list = {}
  for _, snippet in pairs(snippets) do
    table.insert(snippet_list, '• ' .. snippet.trigger)
  end
  
  vim.notify(
    '🎯 Available snippets for ' .. ft .. ':\n\n' ..
    table.concat(snippet_list, '\n') .. '\n\n' ..
    '💡 Use <C-f> to expand snippets, <C-b>/<C-f> to navigate placeholders',
    vim.log.levels.INFO,
    { title = '🚀 NDE Snippets - ' .. ft:upper(), timeout = 10000 }
  )
end

-- Main NDE command handler
local function handle_nde_command(opts)
  local args = vim.split(opts.args, ' ', { trimempty = true })
  local cmd = args[1] or 'help'
  local subcmd = args[2]
  local action = args[3]

  -- Tips commands
  if cmd == 'tips' then
    if subcmd == 'on' then
      tips.enable()
    elseif subcmd == 'off' then
      tips.disable()
    else
      tips.toggle()
    end
    
  elseif cmd == 'tip' then
    if subcmd == 'show' then
      tips.show_current()
    elseif subcmd == 'next' then
      tips.show_next()
    elseif subcmd == 'random' then
      tips.show_random()
    else
      tips.show_current()
    end
    
  -- Dynamic loader commands
  elseif cmd == 'dynamicloader' then
    if subcmd == 'stats' then
      dynamic_loader.nde_stats()
    elseif subcmd == 'languages' then
      dynamic_loader.nde_languages()
    elseif subcmd == 'formatters' then
      dynamic_loader.nde_formatters()
    elseif subcmd == 'clearcache' then
      dynamic_loader.nde_clearcache()
    else
      -- Show dynamic loader help
      vim.notify(
        '🚀 NDE Dynamic Loader Commands:\n\n' ..
        '📊 :NDE dynamicloader stats - Performance overview\n' ..
        '🎯 :NDE dynamicloader languages - Language status\n' ..
        '✨ :NDE dynamicloader formatters - Formatter status\n' ..
        '🧹 :NDE dynamicloader clearcache - Clear all caches\n\n' ..
        '💡 TIP: Tab completion available!',
        vim.log.levels.INFO,
        { title = '🚀 NDE Dynamic Loader Help', timeout = 6000 }
      )
    end
    
  -- Codeium commands
  elseif cmd == 'codeiumauth' then
    if subcmd == 'help' then
      vim.notify(
        "💡 Codeium Authentication Help:\n\n" ..
        "When you run :Codeium Auth, you'll see options like:\n" ..
        "1: Open Default Browser\n" ..
        "2: Copy URL to Clipboard\n" ..
        "3: Display URL\n" ..
        "4: I already have a key\n\n" ..
        "🔥 IMPORTANT: Type a NUMBER (1-4) and press ENTER!\n\n" ..
        "💡 TIP: Option 1 (browser) is usually the easiest",
        vim.log.levels.INFO,
        { title = "🤖 Codeium Auth Help", timeout = 8000 }
      )
    else
      -- Show codeiumauth help
      vim.notify(
        "🤖 NDE Codeium Commands:\n\n" ..
        "📚 :NDE codeiumauth help - Show authentication help\n\n" ..
        "💡 TIP: Run :Codeium Auth to authenticate with Codeium",
        vim.log.levels.INFO,
        { title = "🤖 NDE Codeium Help", timeout = 5000 }
      )
    end
    
  -- Snippets commands
  elseif cmd == 'snippetslist' then
    list_snippets()
    
  -- General commands
  elseif cmd == 'welcome' then
    tips.show_welcome()
    
  elseif cmd == 'status' then
    tips.show_status()
    
  elseif cmd == 'help' or cmd == '' then
    -- Main help menu
    vim.notify(
      '🎯 NDE Command Suite:\n\n' ..
      '💡 TIPS SYSTEM:\n' ..
      '   :NDE tips on/off - Toggle tips\n' ..
      '   :NDE tip show/next/random - Control tips\n\n' ..
      '🚀 DYNAMIC LOADER:\n' ..
      '   :NDE dynamicloader stats - Performance stats\n' ..
      '   :NDE dynamicloader languages - Language status\n' ..
      '   :NDE dynamicloader formatters - Formatter status\n' ..
      '   :NDE dynamicloader clearcache - Clear caches\n\n' ..
      '🤖 CODEIUM:\n' ..
      '   :NDE codeiumauth help - Codeium authentication help\n\n' ..
      '📝 SNIPPETS:\n' ..
      '   :NDE snippetslist - List available snippets for current file\n\n' ..
      '🎉 GENERAL:\n' ..
      '   :NDE welcome - Show welcome message\n' ..
      '   :NDE status - Show NDE status\n\n' ..
      '💡 TIP: All commands support tab completion!',
      vim.log.levels.INFO,
      { title = '🚀 NDE Command Center', timeout = 10000 }
    )
    
  else
    -- Unknown command
    vim.notify(
      '❌ Unknown NDE command: ' .. cmd .. '\n\n' ..
      'Use :NDE help to see all available commands',
      vim.log.levels.WARN,
      { title = '🚀 NDE Command Suite' }
    )
  end
end

-- Tab completion function
local function complete_nde_command(ArgLead, CmdLine, CursorPos)
  local args = vim.split(CmdLine, ' ', { trimempty = true })
  local arg_count = #args
  
  -- If we're still typing the command name
  if CmdLine:sub(-1) ~= ' ' then
    arg_count = arg_count - 1
  end
  
  if arg_count == 1 then
    -- First level commands
    local commands = {
      'help', 'tips', 'tip', 'dynamicloader', 'codeiumauth',
      'snippetslist', 'welcome', 'status'
    }
    return vim.tbl_filter(function(cmd)
      return cmd:match('^' .. vim.pesc(ArgLead))
    end, commands)
    
  elseif arg_count == 2 then
    local cmd = args[2]
    if cmd == 'tips' then
      return { 'on', 'off' }
    elseif cmd == 'tip' then
      return { 'show', 'next', 'random' }
    elseif cmd == 'dynamicloader' then
      return { 'stats', 'languages', 'formatters', 'clearcache' }
    elseif cmd == 'codeiumauth' then
      return { 'help' }
    end
  end
  
  return {}
end

-- Setup the main NDE command
function M.setup()
  vim.api.nvim_create_user_command('NDE', handle_nde_command, {
    nargs = '*',
    complete = complete_nde_command,
    desc = 'NDE Command Suite - Type :NDE help for all commands'
  })
end

return M

