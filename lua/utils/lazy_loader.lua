-- ⚡ NDE v2.0.0 Lazy Loading Framework
-- Ultra-fast startup via smart plugin deferrals

local M = {}

-- Track loaded modules to prevent duplicates
local loaded_modules = {}

-- Background loading queue
local background_queue = {}

-- Defer a function to run after startup
function M.defer(fn, delay)
  delay = delay or 0
  vim.defer_fn(fn, delay)
end

-- Schedule for next tick (non-blocking)
function M.schedule(fn)
  vim.schedule(fn)
end

-- Load on specific events
function M.on_event(events, callback)
  if type(events) == 'string' then events = {events} end
  
  vim.api.nvim_create_autocmd(events, {
    callback = function()
      callback()
      return true -- Remove autocmd after first trigger
    end,
    once = true
  })
end

-- Load on file type
function M.on_filetype(filetypes, callback)
  if type(filetypes) == 'string' then filetypes = {filetypes} end
  
  vim.api.nvim_create_autocmd('FileType', {
    pattern = filetypes,
    callback = function()
      callback()
      return true
    end,
    once = true
  })
end

-- Load on command
function M.on_command(commands, module_path, callback)
  if type(commands) == 'string' then commands = {commands} end
  
  for _, cmd in ipairs(commands) do
    vim.api.nvim_create_user_command(cmd, function(opts)
      -- Load the module first
      if module_path and not loaded_modules[module_path] then
        require(module_path)
        loaded_modules[module_path] = true
      end
      
      -- Execute callback or re-run command
      if callback then
        callback(opts)
      else
        vim.cmd(cmd .. ' ' .. (opts.args or ''))
      end
    end, { nargs = '*', complete = 'file' })
  end
end

-- Load on keymap
function M.on_keymap(key, mode, module_path, callback)
  mode = mode or 'n'
  
  vim.keymap.set(mode, key, function()
    -- Load module if specified
    if module_path and not loaded_modules[module_path] then
      require(module_path)
      loaded_modules[module_path] = true
    end
    
    if callback then
      callback()
    end
  end, { desc = 'Lazy load: ' .. (module_path or 'callback') })
end

-- Background loading (lowest priority)
function M.background_load(modules, delay)
  delay = delay or 5000 -- 5 seconds after startup
  
  M.defer(function()
    for _, module in ipairs(modules) do
      if not loaded_modules[module] then
        pcall(require, module)
        loaded_modules[module] = true
      end
    end
  end, delay)
end

-- Load when Neovim becomes idle
function M.on_idle(callback, delay)
  delay = delay or 1000
  
  M.defer(function()
    callback()
  end, delay)
end

-- Critical path - only for essential startup plugins
function M.essential_load(module)
  if not loaded_modules[module] then
    require(module)
    loaded_modules[module] = true
  end
end

return M

