-- Modified snacks.dashboard with auto-cursor positioning
-- This is a local modification of folke/snacks.nvim dashboard module
-- to add automatic cursor positioning on the first actionable button

local M = setmetatable({}, {
  __call = function(M, opts)
    return M.open(opts)
  end,
})

M.meta = {
  desc = " Beautiful declarative dashboards with auto-focus",
  needs_setup = true,
}

local uv = vim.uv or vim.loop
math.randomseed(os.time())

-- Get the original snacks dashboard
local original_dashboard = require("snacks.dashboard")

-- Copy all original functions and properties
for k, v in pairs(original_dashboard) do
  if k ~= "Dashboard" then
    M[k] = v
  end
end

-- Local dashboard class with cursor positioning
local D = {}

-- Copy all original Dashboard methods
for k, v in pairs(original_dashboard.Dashboard) do
  D[k] = v
end

-- Override the update method to add auto-cursor positioning
function D:update()
  if not (self.buf and vim.api.nvim_buf_is_valid(self.buf)) then
    return
  end
  self.fire("UpdatePre")
  self._size = self:size()

  self.items = self:resolve(self.opts.sections)

  self:layout()
  self:keys()
  self:render()

  -- actions on enter
  vim.keymap.set("n", "<cr>", function()
    local item = self:find(vim.api.nvim_win_get_cursor(self.win))
    return item and item.action and self:action(item.action)
  end, { buffer = self.buf, nowait = true, desc = "Dashboard action" })

  -- cursor movement with auto-positioning
  local last = { 1, 0 }
  
  -- MODIFICATION: Auto-position cursor on first actionable item on initial load
  local function position_cursor()
    vim.notify("🎯 Modified dashboard position_cursor called!", vim.log.levels.INFO)
    local actionable_items = vim.tbl_filter(function(it)
      return it.action and it._
    end, self.items)
    
    vim.notify("Found " .. #actionable_items .. " actionable items", vim.log.levels.INFO)
    
    if #actionable_items > 0 then
      local first_item = actionable_items[1]
      local col = self.lines[first_item._.row]:find("[%w%d%p]", first_item._.col + 1)
      col = col or (first_item._.col + 1 + (first_item.indent and (first_item.indent + 1) or 0))
      last = { first_item._.row, (col or first_item._.col + 1) - 1 }
      vim.notify("Positioning cursor at: " .. last[1] .. "," .. last[2], vim.log.levels.INFO)
      vim.api.nvim_win_set_cursor(self.win, last)
    end
  end
  
  -- Position cursor immediately on initial load
  vim.schedule(position_cursor)
  
  vim.api.nvim_create_autocmd("CursorMoved", {
    group = vim.api.nvim_create_augroup("snacks_dashboard_cursor", { clear = true }),
    buffer = self.buf,
    callback = function()
      local item = self:find(vim.api.nvim_win_get_cursor(self.win), last)
      -- can happen for panes without actionable items
      item = item or vim.tbl_filter(function(it)
        return it.action and it._
      end, self.items)[1]
      if item then
        local col = self.lines[item._.row]:find("[%w%d%p]", item._.col + 1)
        col = col or (item._.col + 1 + (item.indent and (item.indent + 1) or 0))
        last = { item._.row, (col or item._.col + 1) - 1 }
      end
      vim.api.nvim_win_set_cursor(self.win, last)
    end,
  })
  self.fire("UpdatePost")
end

-- Override the open function to use our modified Dashboard class
function M.open(opts)
  local self = setmetatable({}, { __index = D })
  self.opts = Snacks.config.get("dashboard", original_dashboard.defaults or {}, opts)
  self.buf = self.opts.buf or vim.api.nvim_create_buf(false, true)
  self.buf = self.buf == 0 and vim.api.nvim_get_current_buf() or self.buf
  self.win = self.opts.win or Snacks.win({ style = "dashboard", buf = self.buf, enter = true }).win
  self.win = self.win == 0 and vim.api.nvim_get_current_win() or self.win
  self.augroup = vim.api.nvim_create_augroup("snacks_dashboard", { clear = true })
  self:init()
  self:update()
  self.fire("Opened")
  return self
end

-- Keep reference to modified Dashboard class
M.Dashboard = D

return M
