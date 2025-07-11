-- NDE Command Suite
-- Centralized command system for all NDE functionality

local M = {}

-- Import modules
local tips = require('nde.tips')

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
    
  -- Hardmode commands
  elseif cmd == 'hardmode' then
    if subcmd == 'on' then
      local ok, hardtime = pcall(require, 'hardtime')
      if ok then
        hardtime.enable()
        -- Save state persistently using JSON
        tips.save_hardtime(true)
        vim.notify(
          '🔥 Hard Mode ENABLED! 💪\n\n' ..
          'No more lazy hjkl movements!\n' ..
          'Time to level up your Vim skills!\n\n' ..
          '💡 Use :NDE hardmode off to disable\n' ..
          '💾 Setting saved permanently!',
          vim.log.levels.INFO,
          { title = '🚀 NDE Hard Mode' }
        )
      else
        vim.notify(
          '❌ Hardtime plugin not found\n\n' ..
          'Install hardtime.nvim to use this feature',
          vim.log.levels.ERROR,
          { title = '🚀 NDE Hard Mode' }
        )
      end
    elseif subcmd == 'off' then
      local ok, hardtime = pcall(require, 'hardtime')
      if ok then
        hardtime.disable()
        -- Save state persistently using JSON
        tips.save_hardtime(false)
        vim.notify(
          '😌 Hard Mode DISABLED\n\n' ..
          'Back to comfortable editing...\n\n' ..
          '💡 Use :NDE hardmode on to re-enable\n' ..
          '💾 Setting saved permanently!',
          vim.log.levels.INFO,
          { title = '🚀 NDE Hard Mode' }
        )
      else
        vim.notify(
          '❌ Hardtime plugin not found\n\n' ..
          'Install hardtime.nvim to use this feature',
          vim.log.levels.ERROR,
          { title = '🚀 NDE Hard Mode' }
        )
      end
    else
      -- Show current status and help
      local ok, hardtime = pcall(require, 'hardtime')
      local status = 'Unknown'
      if ok then
        local is_enabled = vim.g.nde_hardmode_enabled ~= false -- default to true
        status = is_enabled and '🔥 ENABLED' or '😌 DISABLED'
      end
      
      vim.notify(
        '🔥 NDE Hard Mode Commands:\n\n' ..
        '📊 CURRENT STATUS: ' .. status .. '\n\n' ..
        '🚀 :NDE hardmode on - Enable hard mode (discipline mode)\n' ..
        '😌 :NDE hardmode off - Disable hard mode\n\n' ..
        '💡 WHAT IS HARD MODE?\n' ..
        '• Prevents excessive use of hjkl movements (max 6 repeats)\n' ..
        '• Forces you to use better Vim motions\n' ..
        '• Helps build muscle memory for efficient editing\n' ..
        '• Makes you a better Vim user! 💪\n\n' ..
        '🎯 TIP: Use w, b, f, t, /, ?, etc. instead of hjkl spam!\n' ..
        '💾 Settings are saved permanently between sessions!',
        vim.log.levels.INFO,
        { title = '🚀 NDE Hard Mode Help', timeout = 10000 }
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
    
  -- OptiSpec commands
  elseif cmd == 'optispec' then
    if subcmd == 'status' then
      -- Show OptiSpec status
      local optispec = require('optispec')
      optispec.status()
      
    elseif subcmd == 'browse' then
      -- Open OptiSpec language browser
      local optispec = require('optispec')
      optispec.browse()
      
    elseif subcmd == 'install' then
      -- Install a language
      if action then
        local optispec = require('optispec')
        optispec.install(action)
      else
        vim.notify(
          '📦 OptiSpec Install Command:\n\n' ..
          'Usage: :NDE optispec install <language>\n\n' ..
          'Examples:\n' ..
          '• :NDE optispec install python\n' ..
          '• :NDE optispec install javascript\n' ..
          '• :NDE optispec install rust\n\n' ..
          '💡 TIP: Use :NDE optispec browse to see all available languages',
          vim.log.levels.INFO,
          { title = '🚀 OptiSpec Install' }
        )
      end
      
    elseif subcmd == 'remove' then
      -- Remove a language
      if action then
        local optispec = require('optispec')
        optispec.remove(action)
      else
        vim.notify(
          '🗑️  OptiSpec Remove Command:\n\n' ..
          'Usage: :NDE optispec remove <language>\n\n' ..
          'Examples:\n' ..
          '• :NDE optispec remove python\n' ..
          '• :NDE optispec remove javascript\n\n' ..
          '⚠️  WARNING: This will remove all tools for the language!',
          vim.log.levels.WARN,
          { title = '🚀 OptiSpec Remove' }
        )
      end
      
    elseif subcmd == 'update' then
      -- Update all OptiSpec tools
      local optispec = require('optispec')
      optispec.update()
      
    else
      -- OptiSpec help menu
      vim.notify(
        '🚀 OptiSpec Commands:\n\n' ..
        '📊 :NDE optispec status - Show installed languages\n' ..
        '🌐 :NDE optispec browse - Browse available languages\n' ..
        '📦 :NDE optispec install <lang> - Install language tools\n' ..
        '🗑️ :NDE optispec remove <lang> - Remove language tools\n' ..
        '🔄 :NDE optispec update - Update all tools\n\n' ..
        '💡 FEATURES:\n' ..
        '• 🎯 Zero-bloat start - install only what you need\n' ..
        '• 🧠 Smart diagnostic merging (LSP + linters)\n' ..
        '• ⚡ Auto-detection for 50+ languages\n' ..
        '• 🎨 Beautiful NUI-powered interfaces\n\n' ..
        '🎮 TIP: Open any file and OptiSpec will prompt to install tools!',
        vim.log.levels.INFO,
        { title = '🚀 OptiSpec Language Manager', timeout = 12000 }
      )
    end
    
  elseif cmd == 'help' or cmd == '' then
    -- Main help menu
    vim.notify(
      '🎯 NDE Command Suite:\n\n' ..
      '💡 TIPS SYSTEM:\n' ..
      '   :NDE tips on/off - Toggle tips\n' ..
      '   :NDE tip show/next/random - Control tips\n\n' ..
      '🤖 CODEIUM:\n' ..
      '   :NDE codeiumauth help - Codeium authentication help\n\n' ..
      '🔥 HARD MODE:\n' ..
      '   :NDE hardmode on/off - Toggle Vim motion discipline\n\n' ..
      '📝 SNIPPETS:\n' ..
      '   :NDE snippetslist - List available snippets for current file\n\n' ..
      '🚀 OPTISPEC:\n' ..
      '   :NDE optispec - Smart language management\n' ..
      '   :NDE optispec status - Show installed languages\n' ..
      '   :NDE optispec browse - Browse available languages\n\n' ..
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
      'help', 'tips', 'tip', 'codeiumauth', 'hardmode',
      'snippetslist', 'welcome', 'status', 'optispec'
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
    elseif cmd == 'codeiumauth' then
      return { 'help' }
    elseif cmd == 'hardmode' then
      return { 'on', 'off' }
    elseif cmd == 'optispec' then
      return { 'status', 'browse', 'install', 'remove', 'update' }
    end
    
  elseif arg_count == 3 then
    local cmd = args[2]
    local subcmd = args[3]
    if cmd == 'optispec' and (subcmd == 'install' or subcmd == 'remove') then
      -- Get available languages for completion
      local languages = {
        'python', 'javascript', 'typescript', 'rust', 'go', 'c_cpp', 'java',
        'lua', 'shell', 'yaml', 'json', 'markdown', 'html', 'css', 'vue',
        'react', 'angular', 'svelte', 'php', 'ruby', 'elixir', 'haskell',
        'scala', 'kotlin', 'clojure', 'docker', 'terraform', 'ansible'
      }
      return vim.tbl_filter(function(lang)
        return lang:match('^' .. vim.pesc(ArgLead))
      end, languages)
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

